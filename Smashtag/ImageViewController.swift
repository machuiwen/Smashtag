//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Chuiwen Ma on 10/26/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: Public Model
    
    var imageURL: NSURL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.minimumZoomScale = 0.003
            scrollView.maximumZoomScale = 3.0
            scrollView.delegate = self
        }
    }
    
    // MARK: Private Implementation
    
    private func fetchImage() {
        if let url = imageURL {
            spinner?.startAnimating()
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [ weak weakSelf = self ] in
                if let imageData = NSData(contentsOfURL: url) {
                    if url == weakSelf?.imageURL {
                        dispatch_async(dispatch_get_main_queue()) {
                            weakSelf?.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
    
    private var imageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
//            scrollView?.contentSize = imageView.frame.size
            if let s = scrollView {
                s.contentSize = imageView.frame.size
                if s.contentSize.width != 0 {
                    s.zoomScale = max(scrollView.frame.height / s.contentSize.height, scrollView.frame.width / s.contentSize.width)
                    print("scrollView width: \(s.frame.width) height: \(s.frame.height), imageView width: \(s.contentSize.width) height: \(s.contentSize.height)")
                }
            }
            spinner?.stopAnimating()
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
        //        scrollView.zoomScale = max(scrollView.frame.height / imageView.frame.height, scrollView.frame.width / imageView.frame.width)
        //
        //        print("scrollView width: \(scrollView.frame.width) height: \(scrollView.frame.height), imageView width: \(imageView.frame.width) height: \(imageView.frame.height)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
}
