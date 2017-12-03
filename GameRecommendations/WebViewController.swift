//
//  WebViewController.swift
//  GameRecommendations
//
//  Created by David on 30/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

/*extension UIViewController
{
    func performSegueToReturnBack()
    {
        if let nav = self.navigationController
        {
            nav.popViewController(animated: true)
        }
        else
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
 */

class WebViewController: UIViewController, WKUIDelegate
{
    var gameName : String! = ""

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var navTitle: UINavigationItem!
    
    override func loadView()
    {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        
        startSearch()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //startSearch()
    }
    
    func startSearch()
    {
        navTitle.title = gameName //set title before removing spaces
        
        let urlProper = gameName.replacingOccurrences(of: " ", with: "_")
        let url = "https://en.wikipedia.org/wiki/\(urlProper)"
        let myURL = URL(string: url)!
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func returnToPreviousView(_ sender: Any)
    {
        //print("here")
        self.dismiss(animated: true, completion: nil)
        
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
