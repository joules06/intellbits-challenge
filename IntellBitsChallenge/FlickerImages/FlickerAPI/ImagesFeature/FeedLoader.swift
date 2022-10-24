//
//  FeedLoader.swift
//  FlickerImages
//
//  Created by Julio Rico on 20/10/22.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<FlickerImagesDataModel, Error>
    
    func load(completion: @escaping (Result) -> Void)
}
