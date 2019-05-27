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
    
    @IBAction private func onAllowCellularTap() {
        self.session.configuration.allowsCellularAccess = true
        var text = "Session.configuration.allowsCellularAccess = \(self.session.configuration.allowsCellularAccess)"
        if !self.session.configuration.allowsCellularAccess {
            text += "\n\n🚨🚨🚨🚨🚨🚨\nSetting allowsCellularAccess to true didn't work!\n🚨🚨🚨🚨🚨🚨"
        }
        self.resultsView.text = text
    }
    
    @IBAction private func onRebuildEverythingTap() {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = false
        configuration.waitsForConnectivity = true
        
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

}

extension ViewController: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        DispatchQueue.main.async {
            self.resultsView.text = "Waiting for Wi-Fi..."
        }
    }
}
