//
//  StateMachine.swift
//  SwifterCSV
//
//  Created by Will Richardson on 15/04/16.
//  Copyright © 2016 JavaNut13. All rights reserved.
//

class Accumulator {
    private var field: [Character]
    private var fields: [String]
    
    private let block: ([String]) -> ()
    var count = 0
    private let startAt: Int
    private let delimiter: Character
    
    var hasContent: Bool {
        return field.count > 0 || fields.count > 0
    }
    
    init(block: ([String]) -> (), delimiter: Character, startAt: Int = 0) {
        self.block = block
        self.startAt = startAt
        self.delimiter = delimiter
        field = []
        fields = []
    }
    
    func pushCharacter(char: Character) {
        field.append(char)
    }
    func pushField() {
        fields.append(String(field))
        field = []
    }
    func pushRow() {
        fields.append(String(field))
        if count >= startAt {
            block(fields)
        }
        count += 1
        fields = [String]()
        field = [Character]()
    }
}

enum State {
    case Start // start of line or field
    case ParsingField // inside a field with no quotes
    case ParsingFieldInnerQuotes // escaped quotes in a field
    case ParsingQuotes // field with quotes
    case ParsingQuotesInner // escaped quotes in a quoted field
    
    func nextState(hook: Accumulator, char: Character) throws -> State {
        switch self {
        case Start:
            return stateFromStart(hook, char)
        case .ParsingField:
            return stateFromParsingField(hook, char)
        case .ParsingFieldInnerQuotes:
            return try stateFromParsingFieldInnerQuotes(hook, char)
        case .ParsingQuotes:
            return stateFromParsingQuotes(hook, char)
        case .ParsingQuotesInner:
            return try stateFromParsingQuotesInner(hook, char)
        }
    }
}


private func stateFromStart(hook: Accumulator, _ char: Character) -> State {
    if char == "\"" {
        return .ParsingQuotes
    } else if char == hook.delimiter {
        hook.pushField()
        return .Start
    } else if isNewline(char) {
        hook.pushRow()
        return .Start
    } else {
        hook.pushCharacter(char)
        return .ParsingField
    }
}

private func stateFromParsingField(hook: Accumulator, _ char: Character) -> State {
    if char == "\"" {
        return .ParsingFieldInnerQuotes
    } else if char == hook.delimiter {
        hook.pushField()
        return .Start
    } else if isNewline(char) {
        hook.pushRow()
        return .Start
    } else {
        hook.pushCharacter(char)
        return .ParsingField
    }
}

private func stateFromParsingFieldInnerQuotes(hook: Accumulator, _ char: Character) throws -> State {
    if char == "\"" {
        hook.pushCharacter(char)
        return .ParsingField
    } else {
        throw CSVError.UnexpectedCharacter(char)
    }
}

private func stateFromParsingQuotes(hook: Accumulator, _ char: Character) -> State {
    if char == "\"" {
        return .ParsingQuotesInner
    } else {
        hook.pushCharacter(char)
        return .ParsingQuotes
    }
}

private func stateFromParsingQuotesInner(hook: Accumulator, _ char: Character) throws -> State {
    if char == "\"" {
        hook.pushCharacter(char)
        return .ParsingQuotes
    } else if char == hook.delimiter {
        hook.pushField()
        return .Start
    } else if isNewline(char) {
        hook.pushRow()
        return .Start
    } else {
        throw CSVError.UnexpectedCharacter(char)
    }
}

private func isNewline(char: Character) -> Bool {
    return char == "\n" || char == "\r" || char == "\r\n"
}
