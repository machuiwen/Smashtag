//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by CS193p Instructor on 10/19/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate
{
    // MARK: Public API

    var searchText: String? {
        didSet {
            searchTextField?.text = searchText
            tweets.removeAll()
            lastTwitterRequest = nil
            searchForTweets()
            title = searchText
        }
    }

    var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            tableView.reloadData() // Model changed -> do UITableViewDataSource dance
        }
    }
    
    // MARK: Fetching Tweets

    // if we had a recent last request, just get newer tweets
    // otherwise create a search based on our searchText
    private var twitterRequest: Twitter.Request? {
        if lastTwitterRequest == nil {
            if let query = searchText where !query.isEmpty {
                return Twitter.Request(search: "\(query) -filter:retweets", count: 100)
            }
        }
        return lastTwitterRequest?.requestForNewer
    }

    // track last request to make sure that when data comes back
    // from Twitter that we are still interested in that data
    private var lastTwitterRequest: Twitter.Request?

    // performs twitterRequest
    // when result comes back, dispatch to main queue to update Model
    // turn refresh control on and off as we do so
    private func searchForTweets() {
        if let request = twitterRequest {
            lastTwitterRequest = request
            // we can make the refresh control appear
            // even for searches that were initiated in code
            // but we have to do a little bit of work to
            // ensure that the refresh control is visible after we turn it on
            refreshControl?.beginRefreshing()  // added after lecture
            ensureRefreshControlVisible()      // see extension below
            request.fetchTweets { [weak weakSelf = self] newTweets in
                dispatch_async(dispatch_get_main_queue()) {
                    if request === weakSelf?.lastTwitterRequest {
                        if !newTweets.isEmpty {
                            weakSelf?.tweets.insert(newTweets, atIndex: 0)
                        }
                        weakSelf?.refreshControl?.endRefreshing()
                    }
                }
            }
        } else {
            refreshControl?.endRefreshing()
        }
    }
    
    // after lecture added "? = nil" to argument to this method
    // IBAction methods' arguments are allowed to be Optional
    // what is more, we can default it to nil
    // and leave this method public
    // now users of our MVC can refresh us by calling refresh()
    @IBAction func refresh(sender: UIRefreshControl? = nil) {
        searchForTweets()
    }
    
    // MARK: Search Text Field

    @IBOutlet weak private var searchTextField: UITextField! {
        didSet {
            searchTextField.text = searchText
            searchTextField.delegate = self
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField === searchTextField {
            textField.resignFirstResponder() // hide keyboard
            searchText = textField.text      // initiate search
        }
        return true
    }

    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // all cells will be estimated to be the height in the storyboard
        tableView.estimatedRowHeight = tableView.rowHeight
        // but let autolayout pick the height of cells that become visible
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath)

        let tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        return cell
    }
}

// generic method added to UITableViewController
// if this UITVC's refresh control is spinning
// make sure that it is actually visible on screen

extension UITableViewController {
    func ensureRefreshControlVisible() {
        if let rc = refreshControl where rc.refreshing {
            let tableViewExtraContentFrame = CGRect(x: 0, y: tableView.contentOffset.y, width: tableView.bounds.width, height: abs(tableView.contentOffset.y))
            if tableViewExtraContentFrame.contains(rc.frame) {
                // already visible
            } else {
                tableView.contentOffset = CGPoint(x: 0, y: tableView.contentOffset.y-rc.frame.size.height)
            }
        }
    }
}
