//
// Created by Dylan Wang on 2020/3/21.
// Copyright © 2020 anyshortcut. all rights reserved.
// 

import Foundation

internal func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    var i = items.startIndex
    repeat {
        Swift.print(items[i], separator: separator, terminator: i == (items.endIndex - 1) ? terminator : separator)
        i += 1
    } while i < items.endIndex
    #endif
}
