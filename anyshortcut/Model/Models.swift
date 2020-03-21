//
// Created by Dylan Wang on 2020/3/20.
// Copyright © 2020 anyshortcut. all rights reserved.
// 

import Foundation
import MASShortcut

struct Shortcut: Codable {

    typealias Key = String
    typealias Domain = String

    let id: UInt
    let key: Key
    let url: URL
    let title: String
    let comment: String?
    let domain: Domain
    let openTimes: Int
    let createdTime: Date
    let favicon: URL?

}

typealias PrimaryShortcutArray = [Shortcut]
typealias SecondaryShortcutDictionary = [Shortcut.Domain: [Shortcut]]

struct ShortcutStorage: Storage {

    static var fileName: String { return "anyshortcut.json" }

    let primary: PrimaryShortcutArray
    let secondary: SecondaryShortcutDictionary
}

struct Meta: Storage {
    static var fileName: String { return "meta.json" }
    let token: String
}
