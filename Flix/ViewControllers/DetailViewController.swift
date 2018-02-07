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
    
    
    var movie : [String : Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movie {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
