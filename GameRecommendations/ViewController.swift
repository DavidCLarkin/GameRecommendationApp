//
//  ViewController.swift
//  GameRecommendations
//
//  Created by David on 20/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
{
    
    //var url = "https://api.myjson.com/bins/1411of" //old url
    //var url = "https://api.myjson.com/bins/1bhe67"
    var url = "https://api.myjson.com/bins/1bfpdb"
    var jsonData : JSON = ""
    var games: [Game] = []
    var gamesByGenre: Set<Game> = Set()
    var genreSet: Set<String> = Set()
    var searchPressed = false
    var isFirstLaunch = true
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var genrePicker: UIPickerView!
    
    
    //Used method from online: https://stackoverflow.com/questions/40575686/detect-internet-connection-and-display-uialertview-swift-3 << Link
    override func viewDidAppear(_ animated: Bool)
    {
        searchButton.isUserInteractionEnabled = false
        UIApplication.shared.statusBarStyle = .lightContent
        if Reachability.isConnectedToNetwork() == true
        {
            activityIndicator.startAnimating()
            
            getData()
            isFirstLaunch = false //already have data, dont need internet connection afterwards
            //self.view.isUserInteractionEnabled = true
            
            activityIndicator.stopAnimating()
        }
        else
        {
            if isFirstLaunch //only if its the initial launch
            {
                let controller = UIAlertController(title: "No Internet Detected", message: "This app requires an Internet connection to fetch data upon launch. Quit the app and open it with connectivity enabled. Interactability will now be disabled.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                controller.addAction(ok)
                
                present(controller, animated: true, completion: nil)
                
                //self.view.isUserInteractionEnabled = false
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func getData()
    {
        Alamofire.request(url).validate().responseJSON
        { response in
            
            if response.value == nil //present error to the user
            {
                let controller = UIAlertController(title: "Couldn't Fetch Data", message: "Please try again later.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                controller.addAction(ok)
                
                self.present(controller, animated: true, completion: nil)
            }
            else
            {
                self.jsonData = JSON(response.result.value ?? 0)
                let result = JSON(self.jsonData)["games"].array!
                
                for index in 0...result.count-1
                {
                    var genres = result[index]["genre"].array!
                    
                    let name = result[index]["name"].string!
                    let rating = result[index]["rating"].int!
                    let genre1 = genres[0].string!
                    let genre2 = genres[1].string!
                    
                    self.games.append(Game(name: name, genres: [genre1, genre2], rating: rating)!)
                    
                }
                
                self.makeGenreArray()
                self.genrePicker.delegate = self
                self.genrePicker.dataSource = self
            }
    
        }
    }
    
    func makeGenreArray()
    {
        for game in games
        {
            genreSet.insert(game.genres[0])
            genreSet.insert(game.genres[1])
        }
        
        searchButton.isUserInteractionEnabled = true
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnToMainView(_ segue: UIStoryboardSegue)
    {
        
    }
    
    //Manually searching for a game by genre
    @IBAction func displayGamesByGenre(_ sender: Any)
    {
        if Reachability.isConnectedToNetwork() == true || genreSet.count > 0
        {
            activityIndicator.startAnimating()
            
            searchPressed = true
            pickerView(genrePicker, didSelectRow: genrePicker.selectedRow(inComponent: 0), inComponent: 0)
            //gameTableViewController.tableView.reloadData()
            performSegue(withIdentifier: "GameRecommendSegue", sender: self)
            
            activityIndicator.stopAnimating()
        }
        else
        {
            let controller = UIAlertController(title: "No Internet Detected", message: "Please connect to the internet to search, or restart the app after connecting to the internet.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                
            controller.addAction(ok)
                
            present(controller, animated: true, completion: nil)
        }
    }
    
    
    //Delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return genreSet.count
    }
    
    //Title for each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return genreSet[genreSet.index(genreSet.startIndex, offsetBy: row)]
    }
    
    //Selecting a genre from the picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        gamesByGenre.removeAll() //empty so you can fill upon next search
        if searchPressed
        {
            let value = genreSet[genreSet.index(genreSet.startIndex, offsetBy: row)] as String //genre searched for is genre at selected row
            for game in games
            {
                for genre in game.genres
                {
                    if value == genre //if selected genre is in a game's genre array, then insert into set
                    {
                        gamesByGenre.insert(game)
                        searchPressed = false
                    }
                }
            }
        }
    }
    
    //changing picker view text color
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
    {
        let rowStr = genreSet[genreSet.index(genreSet.startIndex, offsetBy: row)] as String
        return NSAttributedString(string: rowStr, attributes: [NSAttributedStringKey.foregroundColor:UIColor.red])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let nextView = segue.destination as! GameTableViewController
        nextView.gamesByGenre = gamesByGenre
    }
    

    
}

