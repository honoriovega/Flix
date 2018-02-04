//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Honorio Vega on 1/30/18.
//  Copyright © 2018 Honorio Vega. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController,UITableViewDataSource,UISearchBarDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var movies : [[String : Any]] = []
    var refreshControl : UIRefreshControl!
    
     // Set up the alert controller
     let alertController = UIAlertController(title: "Cannot Get Movies", message: "The internet connection appears to be offline.", preferredStyle: .alert)

    var filteredData: [[String : Any]] = []

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
    
    @objc func didPullToRefresh(_ refreshControl : UIRefreshControl) {
        fetchMovies()
    }
    
    func fetchMovies() {

        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        
        
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
                self.filteredData = movies
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
                
            }
        }
        
        task.resume()

    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        
        let placeHolderURL = URL(string: "https://httpbin.org/image/png")!
        let smoke = UIImage(named: "AppIcon")!
        
        cell.posterImageView.af_setImage(withURL: placeHolderURL, placeholderImage: smoke)
        
        
        let placeholderImageURL = URL(string: "https://httpbin.org/image/png")!
                cell.posterImageView.af_setImage(withURL: placeholderImageURL)
        
        let movie = filteredData[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let posterPathString = movie["poster_path"] as! String
        let baseURLString = "https://image.tmdb.org/t/p/w500/"
        let posterURL = URL(string: baseURLString + posterPathString)!
        cell.posterImageView.af_setImage(withURL: posterURL)
        
        return cell
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = searchText.isEmpty ? movies : movies.filter { (item: [String : Any]) -> Bool in
            // If dataItem matches the searchText, return true to include it
            
            let title = item["title"] as! String
            return title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 


}
