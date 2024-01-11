//
//  LanguageTests.swift
//  TokenizerTests
//
//  Created by Somebody on 11/01/2024.
//

import XCTest
@testable import Tokenizer

final class LanguageTests: XCTestCase {
    
    func testTitle() {
        XCTAssertEqual(Language.english.title, "English")
        XCTAssertEqual(Language.spanish.title, "Spanish")
    }
    
    func testKeywords() {
        XCTAssertEqual(Language.english.tokenizationKeywords, [
            "and", "if"
        ])
        XCTAssertEqual(Language.spanish.tokenizationKeywords, [
            "si", "y"
        ])
    }
}
