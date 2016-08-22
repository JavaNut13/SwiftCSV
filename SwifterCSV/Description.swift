//
//  Description.swift
//  SwifterCSV
//
//  Created by Will Richardson on 11/04/16.
//  Copyright © 2016 JavaNut13. All rights reserved.
//

extension CSV: CustomStringConvertible {
    public var description: String {
        let delim = String(self.delimiter)
        let head = header.joinWithSeparator(delim) + "\n"
        
        let rows = try? self.rows()
        
        let cont = rows?.map { row in
            header.map {
                escape(delim, field: row[$0] ?? "")
            }.joinWithSeparator(delim)
        }.joinWithSeparator("\n")
        return head + (cont ?? "")
    }
}

private func escape(delimiter: String, field: String) -> String {
    let quoted = field.stringByReplacingOccurrencesOfString("\"", withString: "\"\"")
    if field.containsString(delimiter) {
        return "\"\(quoted)\""
    } else {
        return quoted
    }
}
