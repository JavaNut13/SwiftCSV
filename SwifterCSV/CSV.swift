//
//  CSV.swift
//  SwifterCSV
//
//  Created by Naoto Kaneko on 2/18/16.
//  Copyright © 2016 Naoto Kaneko, JavaNut13. All rights reserved.
//

public class CSV {
    static let comma: Character = ","
    
    public var header: [String]!
    
    var _rows: [[String: String]]? = nil
    
    let text: String
    public var delimiter: Character
    
    /// Load a CSV file from a string
    ///
    /// - string: string data of the CSV file
    /// - delimiter: character to split row and header fields by (default is ',')
    ///
    /// Throws CSVError if CSV file is invalid
    public init(string: String, delimiter: Character = comma) throws {
        self.text = string
        self.delimiter = delimiter
        
        let createHeader: [String] -> () = { head in
            self.header = head
        }
        try enumerateAsArray(createHeader, limitTo: 1, startAt: 0)
    }
    
    /// Load an existing row dictionary (for exporting)
    ///
    /// - rows: rows to load, a list of dictionaries
    /// - delimiter: delimiter to use when exporting
    /// - loadColumns: whether to populate the columns dictionary (defaults to false)
    public init(rows: [[String: String]], delimiter: Character = comma) {
        // loadColumns is false by default because 99% of the time this will be
        // used to export data, and so it won't be used.
        self.text = ""
        self.delimiter = delimiter
        
        load(rows: rows)
    }
    
    /// Load data from a header array and 2D rows array
    ///
    /// - header: String of column headers
    /// - rows: 2D array of data
    /// - delimiter: The delimiter that will be used when exporting
    public init(header: [String], rows: [[String]], delimiter: Character = comma) {
        self.text = ""
        self.delimiter = delimiter
        
        load(header: header, rows: rows)
    }
}

public enum CSVError: ErrorType {
    case UnexpectedCharacter(Character)
}