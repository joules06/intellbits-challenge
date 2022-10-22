//
//  SharedTestHelpers.swift
//  FlickerImagesTests
//
//  Created by Julio Rico on 20/10/22.
//

import Foundation

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}
