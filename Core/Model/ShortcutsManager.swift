//
// Created by Dylan Wang on 2020/3/20.
// Copyright © 2020 anyshortcut. all rights reserved.
// 

import Foundation
import os.log

public final class ShortcutManager {
    public static let shared = ShortcutManager()
}

// MARK: Fetch

public extension ShortcutManager {

    func getPrimaryShortcuts() -> PrimaryShortcutArray {
        do {
            return try ShortcutStorage.parse().primary
                .filter { $0.key.count == 1 }
        } catch {
            print(error)
            return []
        }
    }

    func getCompoundShortcuts() -> PrimaryShortcutArray {
        do {
            return try ShortcutStorage.parse().primary
                .filter { $0.key.count == 2 }
        } catch {
            print(error)
            return []
        }
    }

    func getSecondaryShortcuts() -> SecondaryShortcutDictionary {
        do {
            return try ShortcutStorage.parse().secondary
        } catch {
            print(error)
            return [:]
        }
    }
}
