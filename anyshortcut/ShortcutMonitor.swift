//
// Created by Dylan Wang on 2020/3/21.
// Copyright © 2020 anyshortcut. all rights reserved.
// 

import Cocoa
import Core
import MASShortcut

struct ShortcutMonitor {

    static func register() {
        registerPrimary()
    }

    static func registerPrimary() {
        let primaryKey: NSEvent.ModifierFlags = .option
        let primary = ShortcutManager.shared.getPrimaryShortcuts()
        primary.forEach { shortcut in
            MASShortcutMonitor.shared()?.register(shortcut.makeMASShortcut(with: primaryKey), withAction: {
                print("open \(shortcut.url)")
                NSWorkspace.shared.open(shortcut.url)
            })
        }
    }

    static func registerCompound() {
        // TODO: issues here, MASShortcut may not support compound key, only compound modifier flags
        let compound = ShortcutManager.shared.getCompoundShortcuts()
        compound.forEach { shortcut in
        }
    }
}

extension Shortcut {
    func makeMASShortcut(with primaryKey: NSEvent.ModifierFlags) -> MASShortcut? {
        precondition(key.count == 1)
        guard let ansiKey = ANSIKey(rawValue: key.lowercased()) else { return nil }
        return MASShortcut(keyCode: ansiKey.keyCode, modifierFlags: primaryKey)
    }

    func compoundMASShort() -> MASShortcut? {
        precondition(key.count == 2)
        let elements = key.compactMap { ANSIKey(rawValue: $0.lowercased()) }
        return nil
    }
}
