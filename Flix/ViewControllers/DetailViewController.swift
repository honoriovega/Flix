//
//  DetailViewController.swift
//  Flix
//
//  Created by Honorio Vega on 2/7/18.
//  Copyright © 2018 Honorio Vega. All rights reserved.
//

import UIKit

// static constants

enum MovieKeys {
    static let title = "title"
    static let backdrop_path = "backdrop_path"
    static let posterPath = "poster_path"
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var backDropImageView: UIImageView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var overViewLabel: UILabel!
    
    var trailerUrl : String!
    
    
    var movie : [String : Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posterImageView.isUserInteractionEnabled = true
        if let movie = movie {
            let movieId = movie["id"] as? Int
            
            // function call to API to get the trailer key
            getTrailerUrl(movieId!)
            titleLabel.text = movie[MovieKeys.title] as? String
            releaseDateLabel.text = movie["release_date"] as? String
            
            overViewLabel.text = movie["overview"] as? String
            
            let backDropPathString = movie[MovieKeys.backdrop_path] as! String
            
            let posterPathString = movie[MovieKeys.posterPath] as! String
            
            let baseURLString = "https://image.tmdb.org/t/p/w500/"
            
            let backdropURL = URL(string : baseURLString + backDropPathString )!
            backDropImageView.af_setImage(withURL: backdropURL)
            
            
            let posterPathURL = URL(string : baseURLString + posterPathString )!
            posterImageView.af_setImage(withURL: posterPathURL)
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movie = movie {
            let playTrailerViewController = segue.destination as! PlayTrailerViewController
            let movieId = movie["id"] as? Int
            getTrailerUrl(movieId!)
            playTrailerViewController.trailerUrl = self.trailerUrl
            
        }
       
    }
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "playTrailer", sender: nil)
    }
    
    func getTrailerUrl(_ movie_id : Int){
        
        let urlString = "https://api.themoviedb.org/3/movie/\(movie_id)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US"
        
        
        let url = URL(string: urlString)!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response,error) in
            
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
              
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                let videos = dataDictionary["results"] as! [[String : Any]]
                let key = videos[0]["key"] as! String
                self.trailerUrl = "https://www.youtube.com/watch?v=\(key)"

            }
        }
        
        task.resume()

    }


}
