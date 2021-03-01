//
//  PhotoRepository.swift
//  Task
//
//  Created by Rashid Khan on 3/1/21.
//

import Foundation

final class PhotoRepositories {
    static func getAll(completion: @escaping(Response<[Item]>)->Void) {
        Store.instance.getAll(endpoint: .albums, clazz: Item.self, params: nil) { (response) in
            completion(response)
        }
    }
}
