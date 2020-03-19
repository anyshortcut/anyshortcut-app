//
//  AppDelegate.swift
//  anyshortcut
//
//  Created by wichna on 12/16/19.
//  Copyright © 2019 anyshortcut. All rights reserved.
//

import Cocoa
import MASShortcut

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        testGooglgMonitor()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

// MARK: - Listen Events

private extension AppDelegate {

    func testGooglgMonitor() {
        let shortcut = MASShortcut(keyCode: kVK_ANSI_G, modifierFlags: [.option, .command])
        let url = URL(string: "https://google.com")!
        MASShortcutMonitor.shared().register(shortcut, withAction: {
            print("open \(url)")
            NSWorkspace.shared.open(url)
        })
    }
}
