//
//  CSVTests.swift
//  CSVTests
//
//  Created by naoty on 2014/06/09.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import XCTest

class CSVTests: XCTestCase {
    var csv: CSV!
    
    override func setUp() {
        csv = try! CSV(string: "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie,20")
    }
    
    func testInit_makesHeader() {
        XCTAssertEqual(csv.header, ["id", "name", "age"])
    }
    
    func testInit_makesRows() {
        XCTAssertEqual(try! csv.rows(), [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": "20"]
        ])
    }
    
    func testInit_whenThereAreIncompleteRows_makesRows() {
        csv = try! CSV(string: "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie")
        XCTAssertEqual(try! csv.rows(), [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": ""]
        ])
    }
    
    func testInit_whenThereAreCRLFs_makesRows() {
        csv = try! CSV(string: "id,name,age\r\n1,Alice,18\r\n2,Bob,19\r\n3,Charlie,20\r\n")
        XCTAssertEqual(try! csv.rows(), [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": "20"]
        ])
    }
    
    func testDescription() {
        XCTAssertEqual(csv.description, "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie,20")
    }
    
    func testEnumerate() {
        let expected = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": "20"]
        ]
        var index = 0
        try! csv.enumerateAsDict { row in
            XCTAssertEqual(row, expected[index])
            index += 1
        }
    }
}