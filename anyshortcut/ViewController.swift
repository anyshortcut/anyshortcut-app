//
//  ViewController.swift
//  anyshortcut
//
//  Created by wichna on 12/16/19.
//  Copyright © 2019 anyshortcut. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var accessTokenTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func loginAction(_ sender: Any) {
        let accessToken = accessTokenTextField.stringValue
        apiClient.login(with: accessToken) { result in
            switch result {
            case .success:
                do {
                    try Meta(token: accessToken).persist()
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}

