//
//  ViewController.swift
//  URLSession
//
//  Created by Casey Liss on 26/5/19.
//  Copyright © 2019 Limitliss. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var session: URLSession!
    private var task: URLSessionTask!
    @IBOutlet private var resultsView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = false
        configuration.waitsForConnectivity = true
        
        // Start a cell-restricted download...
        
        self.session = URLSession(configuration: configuration,
                                  delegate: self,
                                  delegateQueue: nil)
        
        if let url = URL(string: "http://captive.apple.com/hotspot-detect.html") {
            self.task = session.dataTask(with: url) { (data, _, _) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.resultsView.text = String(data: data, encoding: .utf8)
                    }
                }
            }
            task.resume()
        }
    }

    @IBAction private func onAllowCellularTap() {
        // The user has blessed cellular access. Now we have to acquiesce to
        // their wishes.
        
        // At this point, I'm telling the existing URLSession I'd like to permit
        // cellular access.
        
        // Hope: Everything that's already in-flight (and, presumably, waiting)
        //       will automatically be resumed and executed over cellular. No
        //       action is required by me.
        // Expectation: At the least I should be able to .resume() tasks
        //              that are already in-flight.
        // Reality: There's no point in even trying to resume() because setting
        //          allowsCellularAccess to true after a URLSession is created
        //          does nothing.
        
        self.session.configuration.allowsCellularAccess = true
        var text = "Session.configuration.allowsCellularAccess = \(self.session.configuration.allowsCellularAccess)"
        if !self.session.configuration.allowsCellularAccess {
            text += "\n\n🚨🚨🚨🚨🚨🚨\nSetting allowsCellularAccess to true didn't work!\n🚨🚨🚨🚨🚨🚨"
        }
        self.resultsView.text = text
    }
    
    @IBAction private func onRebuildEverythingTap() {
        // Okay, so let's assume I want to brute-force this. I'm willing to
        // stand up a whole new URLSession where allowsCellularAccess is true.
        
        // That means I have to take all the tasks in that URLSession and re-create
        // them by hand.
        
        // The problem here is that if I *can't* re-create everything anymore. I
        // see that I have NSURLSession.getTasksWithCompletionHandler(_:), but I
        // don't have any access to the *request's* completion handler. So there
        // isn't any way for me re-scaffold everything that was in-flight. :(
        
        let oldSession = self.session
        self.session = URLSession(configuration: .default)
        oldSession?.getTasksWithCompletionHandler { [weak self] (dataTasks, _, _) in
            let alert = UIAlertController(title: "Impossible",
                                          message: "There is no mechanism by which I can re-create in-flight tasks. 😭",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Bummer.", style: .default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
                
            }))
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension ViewController: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        DispatchQueue.main.async {
            self.resultsView.text = "Waiting for Wi-Fi..."
        }
    }
}
