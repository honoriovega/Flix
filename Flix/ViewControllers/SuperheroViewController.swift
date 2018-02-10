//
//  SuperheroViewController.swift
//  Flix
//
//  Created by Honorio Vega on 2/7/18.
//  Copyright © 2018 Honorio Vega. All rights reserved.
//

import UIKit

class SuperheroViewController: UIViewController,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
 
    var movies : [[String : Any]] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        
        let cellsPerLine : CGFloat = 2
        let interItemSpacingTotal = layout.minimumLineSpacing * (cellsPerLine - 1)
        let width = collectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        
        layout.itemSize = CGSize(width : width, height:  width * 3.0/2.0)
        
        
        fetchMovies()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        
        let movie = movies[indexPath.item]
        if let posterPathString = movie["poster_path"] as?  String {
            let baseURLString = "https://image.tmdb.org/t/p/w500/"
            let posterURL = URL(string : baseURLString + posterPathString)!
            
            cell.posterImageView.af_setImage(withURL: posterURL)
        }
        return cell
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
            
            if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                let movies = dataDictionary["results"] as! [[String : Any]]
                self.movies = movies
                self.collectionView.reloadData()
                //self.refreshControl.endRefreshing()
                //self.activityIndicator.stopAnimating()
            }
        }
        
        task.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DetailViewController
        let cell = sender as! PosterCell
        let indexPaths = self.collectionView.indexPath(for: cell)
        let movie = self.movies[indexPaths!.row]
        vc.movie = movie


    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
