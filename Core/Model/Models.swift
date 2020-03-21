//
// Created by Dylan Wang on 2020/3/20.
// Copyright © 2020 anyshortcut. all rights reserved.
// 

import Foundation

public struct Shortcut: Codable {

    public typealias Key = String
    public typealias Domain = String

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

public struct ShortcutStorage: Storage {

    public static var fileName: String { return "anyshortcut.json" }

    let primary: PrimaryShortcutArray
    let secondary: SecondaryShortcutDictionary
}

public struct Meta: Storage {

    public static var fileName: String { return "meta.json" }

    public let token: String

    public init(token: String) {
        self.token = token
    }
}
