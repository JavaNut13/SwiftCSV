//
//  ExportTests.swift
//  SwifterCSV
//
//  Created by Will Richardson on 17/04/16.
//  Copyright © 2016 JavaNut13. All rights reserved.
//

import XCTest

class ImportTests: XCTestCase {

    func testImportFromRows() {
        let rows = [
            ["thing": "window", "size": "large"],
            ["thing": "laptop", "size": "small"]
        ]
        let csv = CSV(rows: rows)
        XCTAssertEqual(try! csv.rows(), rows)
        let desc = "size,thing\nlarge,window\nsmall,laptop"
        XCTAssertEqual(csv.description, desc)
    }
    
    func testImportFromArray() {
        let header = ["Thing", "Stuff", "More things"]
        let rows = [
            ["Field1", "Field2", "Field3"],
            ["Test rows", "More data", "Another"]
        ]
        let csv = CSV(header: header, rows: rows)
        XCTAssertEqual(csv.description,
                       "Thing,Stuff,More things\nField1,Field2,Field3\nTest rows,More data,Another")
    }
}
