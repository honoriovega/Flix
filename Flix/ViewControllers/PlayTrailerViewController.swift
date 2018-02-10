//
//  PlayTrailerViewController.swift
//  Flix
//
//  Created by Honorio Vega on 2/10/18.
//  Copyright © 2018 Honorio Vega. All rights reserved.
//

import UIKit

class PlayTrailerViewController: UIViewController {
    
    
    var perkeset : String!
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Convert the url String to a NSURL object.
        let requestURL = URL(string:perkeset)
        // Place the URL in a URL Request.
        let request = URLRequest(url: requestURL!)
        // Load Request into WebView.
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissModal(_ sender: Any) {
        
        self.presentingViewController?.dismiss(animated: false, completion:nil)

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
