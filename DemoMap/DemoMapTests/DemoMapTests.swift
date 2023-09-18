//
//  DemoMapTests.swift
//  DemoMapTests
//
//  Created by Mustafa Yanar on 18.09.2023.
//

import XCTest
import DemoMap

final class DemoMapTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testStringToCoordinate2D() throws {
        let string = "41.000, 29.000"
        guard let (coordinateX, coordinateY) = string.coordinate2D() else { return }
        XCTAssertTrue(coordinateX == 41.0)
        XCTAssertTrue(coordinateY == 29.0)
    }
}
