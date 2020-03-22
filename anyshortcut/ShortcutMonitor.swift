//
// Created by Dylan Wang on 2020/3/21.
// Copyright © 2020 anyshortcut. all rights reserved.
// 

import Cocoa
import Core
import MASShortcut

class ShortcutMonitor {

    static let primaryKey: NSEvent.ModifierFlags = .option

    static private var recoverTimer: Timer?

    static func register() {
        registerPrimary()
        registerCompound()
    }

    static func registerPrimary() {
        let primary = ShortcutManager.shared.getPrimaryShortcuts()
        primary.forEach { shortcut in
            MASShortcutMonitor.shared()?.register(shortcut.makeMASShortcut(with: primaryKey), withAction: {
                print("open primary shortcut: \(shortcut.url)")
                NSWorkspace.shared.open(shortcut.url)
            })
        }
    }

    static func unregisterPrimary() {
        let primary = ShortcutManager.shared.getPrimaryShortcuts()
        primary.forEach { shortcut in
            MASShortcutMonitor.shared()?.unregisterShortcut(shortcut.makeMASShortcut(with: primaryKey))
        }
    }

    static func registerCompound() {
        // TODO: Handle conflic with primary
        let recoverInterval: TimeInterval = 0.5
        let compound = ShortcutManager.shared.getCompoundShortcuts()
        for shortcut in compound {
            let masShortcuts = shortcut.compoundMASShort(with: primaryKey)
            guard masShortcuts.count == 2 else { continue }
            let first = masShortcuts.first
            let last = masShortcuts.last
            MASShortcutMonitor.shared()?.register(first, withAction: {
                unregisterPrimary()
                recoverTimer = Timer(timeInterval: recoverInterval,
                                     target: self,
                                     selector: #selector(recoverPrimaryShortcut(_:)),
                                     userInfo: last,
                                     repeats: false)
                RunLoop.current.add(self.recoverTimer!, forMode: RunLoop.Mode.common)

                MASShortcutMonitor.shared()?.register(last, withAction: {
                    print("open compound shortcut: \(shortcut.url)")
                    NSWorkspace.shared.open(shortcut.url)
                })
            })

        }
    }

    static func unregisterCompound() {
        let compound = ShortcutManager.shared.getCompoundShortcuts()
        let allFirst = compound.compactMap { $0.compoundMASShort(with: primaryKey).first }
        for shortcut in allFirst {
            MASShortcutMonitor.shared()?.unregisterShortcut(shortcut)
        }
    }
}

private extension ShortcutMonitor {
    @objc static func recoverPrimaryShortcut(_ timer: Timer) {
        if let last = timer.userInfo as? MASShortcut {
            MASShortcutMonitor.shared()?.unregisterShortcut(last)
        }
        recoverTimer?.invalidate()
        recoverTimer = nil

        registerPrimary()
    }
}

extension Shortcut {
    func makeMASShortcut(with primaryKey: NSEvent.ModifierFlags) -> MASShortcut? {
        precondition(key.count == 1)
        guard let ansiKey = ANSIKey(rawValue: key.lowercased()) else { return nil }
        return MASShortcut(keyCode: ansiKey.keyCode, modifierFlags: primaryKey)
    }

    func compoundMASShort(with primaryKey: NSEvent.ModifierFlags) -> [MASShortcut] {
        precondition(key.count == 2)
        return key.compactMap {
            guard let ansiKey = ANSIKey(rawValue: $0.lowercased()) else { return nil }
            return MASShortcut(keyCode: ansiKey.keyCode, modifierFlags: primaryKey)
        }
    }
}
