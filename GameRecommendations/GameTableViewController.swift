//
//  GameTableViewController.swift
//  GameRecommendations
//
//  Created by David on 23/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class GameTableViewController: UITableViewController
{
    //MARK: Properties
    var mainViewController: ViewController = ViewController(nibName: nil, bundle: nil)
    var gamesByGenre: Set<Game> = Set()
    var gamesByGenreSorted: [Game] = []
    var first = true
    var firstAlphaSort = true
    var gameName : String! = ""
    var webSearchClick = false
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return gamesByGenre.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if first //only set the array the first time so it can be sortable
        {
            gamesByGenreSorted = Array(self.gamesByGenre)
            first = false
        }
        
        let cellIdentifier = "GameTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GameTableViewCell else
        {
            fatalError("Cell not instance of GameTableViewCell")
        }
        //let game = gamesByGenre[gamesByGenre.index(gamesByGenre.startIndex, offsetBy: indexPath.row)]
        
        let game = gamesByGenreSorted[indexPath.row]
        cell.gameNameLabel.text = game.name
        cell.ratingLabel.text = "Rating: \(String(describing: game.rating))"
        
        
        return cell
    }
    
    
    @IBAction func sortByGreaterRating(_ sender: Any)
    {
        gamesByGenreSorted = self.gamesByGenre.sorted(by: >)
        tableView.reloadData()
        
    }
    
    @IBAction func sortByLowerRating(_ sender: Any)
    {
        gamesByGenreSorted = self.gamesByGenre.sorted(by: <)
        tableView.reloadData()
    }
    
    @IBAction func sortAlphabetically(_ sender: Any)
    {
        if firstAlphaSort //sort either up or down based on the variable
        {
            gamesByGenreSorted = gamesByGenreSorted.sorted{ $0.name < $1.name }
        }
        else
        {
            gamesByGenreSorted = gamesByGenreSorted.sorted{ $0.name > $1.name }
        }
        firstAlphaSort = !firstAlphaSort
        
        tableView.reloadData()
    }
    
    /*@IBAction func webSearch(_ sender: UIButton)
    {
        webSearchClick = true
        //NOT SELECTING THE CORRECT ONE
        let selectedIndexPath = IndexPath(row: sender.tag, section: 0)
        print(selectedIndexPath)
        
        let selectedCell = tableView.cellForRow(at: selectedIndexPath) as! GameTableViewCell
        
        gameName = selectedCell.gameNameLabel.text!
        print(gameName)
        performSegue(withIdentifier: "WebSearchSegue", sender: self)
    }
 */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if webSearchClick && Reachability.isConnectedToNetwork() == true //only do this if the user searches for a game by clicking the cell
        {
            let navc = segue.destination as! UINavigationController //allow a nav bar on top of web view
            let vc = navc.topViewController as! WebViewController
            vc.gameName = gameName
            webSearchClick = false
        }
        else if webSearchClick && Reachability.isConnectedToNetwork() == false
        {
            let controller = UIAlertController(title: "No Internet Connection", message: "An internet connection is required to search for a game. Please connect to the internet to search.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            controller.addAction(ok)
            
            present(controller, animated: true, completion: nil)
            
            //self.view.isUserInteractionEnabled = false
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        webSearchClick = true
        let selectedCell = tableView.cellForRow(at: indexPath) as! GameTableViewCell
        gameName = selectedCell.gameNameLabel.text!
        //print(gameName)
        performSegue(withIdentifier: "WebSearchSegue", sender: self)
    }
 
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
}
