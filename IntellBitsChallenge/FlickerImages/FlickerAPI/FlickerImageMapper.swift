//
//  FlickerImageMapper.swift
//  FlickerImages
//
//  Created by Julio Rico on 21/10/22.
//

import Foundation
struct RemoteFlickImage: Decodable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String?
}

struct RemoteFlickerImagesDataModel: Decodable {
    let page: Int
    let pages: Int
    let perPage: Int
    let total: Int
    let photo: [RemoteFlickImage]
    
    enum CodingKeys: String, CodingKey {
        case page, pages, total, photo
        case perPage = "perpage"
    }
}


internal final class FlickerImageMapper {
    private struct Root: Decodable {
        let photos: RemoteFlickerImagesDataModel
        let stat: String
    }
    
    private static var OK_200: Int { 200 }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> RemoteFlickerImagesDataModel {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFlickerFeedLoader.Error.invalidData
        }
        
        return root.photos
    }
}


