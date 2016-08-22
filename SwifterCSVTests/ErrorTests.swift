//
//  ErrorTests.swift
//  SwifterCSV
//
//  Created by Will Richardson on 22/08/16.
//  Copyright © 2016 JavaNut13. All rights reserved.
//

import XCTest

class ErrorTests: XCTestCase {
    func testInvalidQuote() throws {
        do {
            print(try CSV(string: "foo,foo\"bar"))
            XCTFail("Constructor should have failed")
        } catch CSVError.UnexpectedCharacter(let exp, let was) {
            XCTAssertEqual(exp, "\"")
            XCTAssertEqual(was, "b")
        }
    }
    
    func testNoEndQuote() throws {
        do {
            print(try CSV(string: "foo,\"foo"))
            XCTFail("Constructor should have failed")
        } catch CSVError.UnexpectedCharacter(let exp, let was) {
            XCTAssertEqual(exp, "\"")
            XCTAssertEqual(was, "b")
        }
    }
}
