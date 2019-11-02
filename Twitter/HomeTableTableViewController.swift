//
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by Abdi Mohamud on 11/1/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadTweets()
        
        //Refresh tweets when you pull down
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    @objc func loadTweets(){
        
        numberOfTweets = 10
        
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count" : numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams, success: { (tweets : [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets
            {
                self.tweetArray.append(tweet)
                
            }
            //reload data
            self.tableView.reloadData()
            //end refresh after data is reloaded
            self.myRefreshControl.endRefreshing()

        }, failure: { (Error) in
            print(Error)
            print("Couldn't retrieve tweets!")
        })
        
    }
    
    func loadMoreTweets(){
        
        
        
        numberOfTweets = numberOfTweets + 2
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count" : numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams, success: { (tweets : [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets
            {
                self.tweetArray.append(tweet)
                
            }
            //reload data
            self.tableView.reloadData()
            //end refresh after data is reloaded
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print(Error)
            print("Couldn't retrieve tweets!")
        })
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userloggedIn")
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.username.text = user["name"] as? String
        
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        let imageURL = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageURL!)
        
        if let imageData = data {
            cell.profileImage.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }

   
}
