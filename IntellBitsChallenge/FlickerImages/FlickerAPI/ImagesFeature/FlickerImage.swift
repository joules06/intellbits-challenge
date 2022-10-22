//
//  FlickerImage.swift
//  FlickerImages
//
//  Created by Julio Rico on 20/10/22.
//

import Foundation

public struct FlickerImage: Equatable {
    public let id: String
    public let owner: String
    public let secret: String
    public let server: String
    public let farm: Int
    public let title: String?
    
    public init(id: String, owner: String, secret: String, server: String, farm: Int, title: String?) {
        self.id = id
        self.owner = owner
        self.secret = secret
        self.server = server
        self.farm = farm
        self.title = title
        
    }
}

extension FlickerImage {
    public func imageURL(imageSize: FlickImageSizes) -> String {
        "\(K.FLICKR_IMAGE_PREFIX)/\(server)/\(id)_\(K.FLICKR_API)_\(imageSize.rawValue).jpg"
    }
}
