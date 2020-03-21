//
//  AppDelegate.swift
//  anyshortcut
//
//  Created by wichna on 12/16/19.
//  Copyright © 2019 anyshortcut. All rights reserved.
//

import Cocoa
import Core
import MASShortcut

let apiClient = APIClient.shared

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // NSApp.setActivationPolicy(.accessory)

        ShortcutMonitor.register()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

// MARK: - Listen Events

private extension AppDelegate {

}
