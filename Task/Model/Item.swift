//
//  Item.swift
//  Task
//
//  Created by Rashid Khan on 3/2/21.
//

import Foundation

struct Item: Codable {
    var albumId: Int
    var id: Int?
    var title: String?
    var url: String?
    var thumbnailUrl: String?
}
