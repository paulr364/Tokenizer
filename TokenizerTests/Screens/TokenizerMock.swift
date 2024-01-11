//
//  TokenizerMock.swift
//  TokenizerTests
//
//  Created by Somebody on 11/01/2024.
//

import Foundation
@testable import Tokenizer

final class TokenizerMock: Tokenizable {
    var string: String?
    var language: Language?
    var sentences: [String] = []
    
    func tokenize(string: String, language: Language) -> [String] {
        self.string = string
        self.language = language
        return sentences
    }
}
