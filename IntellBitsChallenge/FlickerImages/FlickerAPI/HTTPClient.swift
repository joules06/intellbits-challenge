//
//  HTTPClient.swift
//  FlickerImages
//
//  Created by Julio Rico on 20/10/22.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    /// The completion handler can be inovked in any thread.
    /// Clients are responsible to dipsatch to appropiate threads, if needed.
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
