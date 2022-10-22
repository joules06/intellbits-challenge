//
//  EssentialFeedAPIEndToEndTests.swift
//  FlickerImagesTests
//
//  Created by Julio Rico on 20/10/22.
//
import FlickerImages
import XCTest

final class EssentialFeedAPIEndToEndTests: XCTestCase {

    func test_endToEndTestServerGETFeedResult_matchesFixedTestAccountData() {
        switch getFeedResult() {
        case let .success(imageFeed)?:
            XCTAssertEqual(imageFeed.count, 10, "Expected 8 images in the test account feed")
            XCTAssertEqual(imageFeed[0], expectedImage(at: 0))
            XCTAssertEqual(imageFeed[1], expectedImage(at: 1))
            XCTAssertEqual(imageFeed[2], expectedImage(at: 2))
            XCTAssertEqual(imageFeed[3], expectedImage(at: 3))
            XCTAssertEqual(imageFeed[4], expectedImage(at: 4))
            XCTAssertEqual(imageFeed[5], expectedImage(at: 5))
            XCTAssertEqual(imageFeed[6], expectedImage(at: 6))
            XCTAssertEqual(imageFeed[7], expectedImage(at: 7))
            XCTAssertEqual(imageFeed[8], expectedImage(at: 8))
            XCTAssertEqual(imageFeed[9], expectedImage(at: 9))
            
        case let .failure(error)?:
            XCTFail("Expected successful feed result, got \(error) instead")
            
        default:
            XCTFail("Expected successful feed result, got no result instead")
        }
    }
    
    private func getFeedResult(file: StaticString = #file, line: UInt = #line) -> FeedLoader.Result? {
        let testServerURL = URL(string: "https://sealetoy-studios.com/json/flick.json")!
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let loader = RemoteFlickerFeedLoader(url: testServerURL, client: client)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: FeedLoader.Result?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
        
        return receivedResult
    }
    
    private func expectedImage(at index: Int) -> FlickerImage {
        return FlickerImage(
            id: id(at: index),
            owner: owner(at: index),
            secret: secret(at: index),
            server: server(at: index),
            farm: farm(at: index),
            title: title(at: index))
    }
    
    private func id(at index: Int) -> String {
        [
            "52444424761",
            "52444939428",
            "52444805720",
            "52444792470",
            "52443829862",
            "52444344761",
            "52444813408",
            "52444738995",
            "52444296391",
            "52444723825"
        ][index]
    }
    
    private func owner(at index: Int) -> String {
        [
            "35797910@N08",
            "47089878@N03",
            "93440264@N04",
            "53731740@N07",
            "53731740@N07",
            "53731740@N07",
            "53731740@N07",
            "53731740@N07",
            "53731740@N07",
            "53731740@N07"
        ][index]
    }
    
    private func secret(at index: Int) -> String {
        [
            "a9c58056d3",
            "db993db1b0",
            "790cf5111a",
            "e441f126fc",
            "277f463ecd",
            "8cd6c85c48",
            "12fa1b4107",
            "9d75a6f32e",
            "061f275734",
            "0c3582d197"
        ][index]
    }
    
    private func server(at index: Int) -> String {
        [
            "65535",
            "65535",
            "65535",
            "65535",
            "65535",
            "65535",
            "65535",
            "65535",
            "65535",
            "65535"
        ][index]
    }
    
    private func farm(at index: Int) -> Int {
        [
            66,
            66,
            66,
            66,
            66,
            66,
            66,
            66,
            66,
            66
        ][index]
    }
    
    private func title(at index: Int) -> String? {
        [
            "NYC100816",
            "Preparation",
            "HS🍎S! Apple corer and slicer",
            "Snowcapped Maroon Bells Peak Autumn Aspens Colorado Colors Sunrise Reflections Fall Foliage Fuji GFX100s Fine Art Landscape Nature Photography Snowmass Wilderness CO! 45SPIC Dr. Elliot McGucken Fuji GFX 100s Master Fine Art Medium Format Photography!",
            "Snowcapped Maroon Bells Peak Autumn Aspens Colorado Colors Sunrise Reflections Fall Foliage Fuji GFX100s Fine Art Landscape Nature Photography Snowmass Wilderness CO! 45SPIC Dr. Elliot McGucken Fuji GFX 100s Master Fine Art Medium Format Photography!",
            "Snowcapped Maroon Bells Peak Autumn Aspens Colorado Colors Sunrise Reflections Fall Foliage Fuji GFX100s Fine Art Landscape Nature Photography Snowmass Wilderness CO! 45SPIC Dr. Elliot McGucken Fuji GFX 100s Master Fine Art Medium Format Photography!",
            "Silver Jack Reservoir  Overlook Panorama  Owl Creek Pass Ridgway Colorado Briliant Autumn Colors! Fall Foliage Aspens Fine Art Landscape Nature Photography Fuji GFX100s! 45EPIC Elliot McGucken Master Fine Art Luxury Photography CO Fine Art Fuji GFX 100s",
            "Silver Jack Reservoir  Overlook Panorama  Owl Creek Pass Ridgway Colorado Briliant Autumn Colors! Fall Foliage Aspens Fine Art Landscape Nature Photography Fuji GFX100s! 45EPIC Elliot McGucken Master Fine Art Luxury Photography CO Fine Art Fuji GFX 100s",
            "Silver Jack Reservoir  Overlook Panorama  Owl Creek Pass Ridgway Colorado Briliant Autumn Colors! Fall Foliage Aspens Fine Art Landscape Nature Photography Fuji GFX100s! 45EPIC Elliot McGucken Master Fine Art Luxury Photography CO Fine Art Fuji GFX 100s",
            "Durango Silverton Steam Engine Train Iron Horse Narrow Gauge Railroad Colorado Autumn Colors Fall Foliage Aspens  Fine Art Landscape Nature Tain Photography Fuji Sony A1 Alpha 1 ! 45EPIC Dr. Elliot McGucken Master Fine Art Luxury Photography CO Fine Art"
        ][index]
    }
}
