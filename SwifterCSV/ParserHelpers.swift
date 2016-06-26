//
//  Parser.swift
//  SwifterCSV
//
//  Created by Will Richardson on 11/04/16.
//  Copyright © 2016 JavaNut13. All rights reserved.
//

extension CSV {
    /// List of dictionaries that contains the CSV data
    public var rows: [[String: String]]? {
        if _rows == nil {
            do {
                try parse()
            } catch {
                return nil
            }
        }
        return _rows
    }
    
    /// Parse the file and call a block for each row, passing it as a dictionary
    public func enumerateAsDict(block: [String: String] -> ()) throws {
        let enumeratedHeader = header.enumerate()
        
        try enumerateAsArray { fields in
            var dict = [String: String]()
            for (index, head) in enumeratedHeader {
                dict[head] = index < fields.count ? fields[index] : ""
            }
            block(dict)
        }
    }
    
    /// Parse the file and call a block on each row, passing it in as a list of fields
    public func enumerateAsArray(block: [String] -> ()) throws {
        try self.enumerateAsArray(block, limitTo: nil, startAt: 1)
    }
    
    private func parse() throws {
        var rows = [[String: String]]()
        
        try enumerateAsDict { dict in
            rows.append(dict)
        }
        _rows = rows
    }
}
