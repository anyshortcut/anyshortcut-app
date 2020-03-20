//
// Created by Dylan Wang on 2020/3/20.
// Copyright © 2020 anyshortcut. all rights reserved.
// 

import XCTest
@testable import anyshortcut

class anyshortcutTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecodeShortcutData() {
        do {
            let data = resposnData.data(using: .utf8)!
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let shortcutData = try decoder.decode(ShortcutStorage.self, from: data)
            XCTAssert(shortcutData.primary.count == 8)
        } catch {
            print(error)
            XCTFail()
        }
    }

}

let resposnData =
"""
{
  "primary": [
    {
      "comment": "Amazon",
      "created_time": 1584614800000,
      "domain": "amazon.com",
      "domain_id": 142,
      "favicon": "https://www.amazon.com/favicon.ico",
      "id": 10752,
      "key": "A",
      "open_times": 0,
      "primary": true,
      "title": "Amazon.com: Online Shopping for Electronics, Apparel, Computers, Books, DVDs & more",
      "updated_time": 1584614800000,
      "url": "https://www.amazon.com/",
      "user_id": 1650
    },
    {
      "comment": "Facebook",
      "created_time": 1584614800000,
      "domain": "facebook.com",
      "domain_id": 144,
      "favicon": "https://www.facebook.com/favicon.ico",
      "id": 10753,
      "key": "F",
      "open_times": 1,
      "primary": true,
      "title": "Be Connected. Be Discovered. Be on Facebook.",
      "updated_time": 1584614800000,
      "url": "https://www.facebook.com/",
      "user_id": 1650
    },
    {
      "comment": "Google",
      "created_time": 1584613655000,
      "domain": "google.com",
      "domain_id": 16,
      "favicon": "https://www.google.com/images/branding/product/ico/googleg_lodp.ico",
      "id": 10750,
      "key": "G",
      "open_times": 6,
      "primary": true,
      "title": "Google",
      "updated_time": 1584613655000,
      "url": "https://www.google.com/",
      "user_id": 1650
    },
    {
      "comment": "Netflix",
      "created_time": 1584614800000,
      "domain": "netflix.com",
      "domain_id": 149,
      "favicon": "https://assets.nflxext.com/us/ffe/siteui/common/icons/nficon2016.ico",
      "id": 10754,
      "key": "N",
      "open_times": 0,
      "primary": true,
      "title": "Netflix - Watch TV Shows Online, Watch Movies Online",
      "updated_time": 1584614800000,
      "url": "https://www.netflix.com/",
      "user_id": 1650
    },
    {
      "comment": "Reddit",
      "created_time": 1584614800000,
      "domain": "reddit.com",
      "domain_id": 51,
      "favicon": "https://www.redditstatic.com/favicon.ico",
      "id": 10755,
      "key": "R",
      "open_times": 0,
      "primary": true,
      "title": "reddit: the front page of the internet",
      "updated_time": 1584614800000,
      "url": "https://www.reddit.com/",
      "user_id": 1650
    },
    {
      "comment": "Twitter",
      "created_time": 1584614800000,
      "domain": "twitter.com",
      "domain_id": 53,
      "favicon": "https://abs.twimg.com/favicons/favicon.ico",
      "id": 10756,
      "key": "T",
      "open_times": 2,
      "primary": true,
      "title": "Twitter",
      "updated_time": 1584614800000,
      "url": "https://twitter.com/",
      "user_id": 1650
    },
    {
      "comment": "anyshortcut-macos",
      "created_time": 1584621581000,
      "domain": "github.com",
      "domain_id": 13,
      "favicon": "https://github.githubassets.com/favicon.ico",
      "id": 10758,
      "key": "X",
      "open_times": 4,
      "primary": true,
      "title": "anyshortcut-macos",
      "updated_time": 1584621581000,
      "url": "https://github.com/anyshortcut/anyshortcut-app/projects/1",
      "user_id": 1650
    },
    {
      "comment": "Youtube",
      "created_time": 1584614800000,
      "domain": "youtube.com",
      "domain_id": 147,
      "favicon": "https://www.youtube.com/yts/img/favicon_32-vflOogEID.png",
      "id": 10757,
      "key": "Y",
      "open_times": 0,
      "primary": true,
      "title": "Youtube",
      "updated_time": 1584614800000,
      "url": "https://www.youtube.com/",
      "user_id": 1650
    }
  ],
  "secondary": {
    "google.com": [
      {
        "comment": "Inbox",
        "created_time": 1584613655000,
        "domain": "google.com",
        "domain_id": 16,
        "favicon": "https://ssl.gstatic.com/bt/C3341AA7A1A076756462EE2E5CD71C11/ic_product_inbox_16dp_r2_2x.png",
        "id": 10751,
        "key": "I",
        "open_times": 0,
        "primary": false,
        "title": "Google Inbox",
        "updated_time": 1584613655000,
        "url": "https://inbox.google.com/",
        "user_id": 1650
      }
    ]
  }
}
"""
