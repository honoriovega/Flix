//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Honorio Vega on 1/30/18.
//  Copyright © 2018 Honorio Vega. All rights reserved.
//

import UIKit
import AlamofireImage

// taken from https://gist.github.com/ViccAlexander/0224ab078f76a3af6d79986369d5240b
extension String {
    /**
     Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
     
     - Parameter length: A `String`.
     - Parameter trailing: A `String` that will be appended after the truncation.
     
     - Returns: A `String` object.
     */
    func truncate(length: Int, trailing: String = "…") -> String {
        if self.characters.count > length {
            return String(self.characters.prefix(length)) + trailing
        } else {
            return self
        }
    }
}


class NowPlayingViewController: UIViewController,UITableViewDataSource,UISearchBarDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var movies : [[String : Any]] = []
    var refreshControl : UIRefreshControl!
    
     // Set up the alert controller
     let alertController = UIAlertController(title: "Cannot Get Movies", message: "The internet connection appears to be offline.", preferredStyle: .alert)

    override func viewDidLoad() {

        super.viewDidLoad()
        activityIndicator.startAnimating()
        searchBar.delegate = self

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        tableView.dataSource = self
        
        
        // create an OK action
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
            self.fetchMovies()
        }
        // add the OK action to the alert controller
        alertController.addAction(tryAgainAction)

        fetchMovies()
        

    }
    
    
    func fetchMovies(query : String = "") {
        
        var url : URL!
        
        // If the query is empty just fetch the latest movies
        if(query.isEmpty) {
            url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
            
            // otherwise query for the search term provided
        } else {
            let query = query.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            
            
            url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&query=" + query)!
        }
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response,error) in
            
            // This will run when the network request returns
            
            if let error = error {
                print(error.localizedDescription)
                
                self.present(self.alertController, animated: true) {
                    
                }
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                let movies = dataDictionary["results"] as! [[String : Any]]
                self.movies = movies
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
            }
        }
        
        task.resume()
        
    }
    
    @objc func didPullToRefresh(_ refreshControl : UIRefreshControl) {
        fetchMovies()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        
        // Placeholders
        let placeHolderURL = URL(string: "http://l.yimg.com/os/mit/media/m/entity/images/movie_placeholder-103642.png")!
        let placeholderImage = UIImage(named: "now_playing_tabbar_item")!
        
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: cell.posterImageView.frame.size,
            radius: 20.0
        )
        
        cell.posterImageView.af_setImage(
            withURL: placeHolderURL,
            placeholderImage: placeholderImage,
            filter: filter,
            imageTransition: .crossDissolve(0.2)
        )
  
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.full_overview = overview
        cell.overviewLabel.text = overview.truncate(length: 140,trailing: "...")

        // If image is available use it
        if let posterPathString = movie["poster_path"] as? String {
            
            let baseURLString = "https://image.tmdb.org/t/p/w500/"
            let posterURL = URL(string: baseURLString + posterPathString)!
            cell.posterImageView.af_setImage(withURL: posterURL)
        }
        
        return cell
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(!searchText.isEmpty) {
            fetchMovies(query : searchText)

        } else {
            fetchMovies()
        }
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 


}
