//
//  NLTokenizer+KeywordRangeSearching.swift
//  Tokenizer
//
//  Created by Somebody on 11/01/2024.
//

import NaturalLanguage

final class KeywordRangeSearcher {
    
    private lazy var tokenizer = NLTokenizer(unit: .word)
}

extension KeywordRangeSearcher: KeywordRangeSearching {
    
    func setLanguage(language: Language) {
        let language = NLLanguage(language: language)
        tokenizer.setLanguage(language)
    }
    
    func keywordRange(in string: String, inRange range: Range<String.Index>, keywords: Set<String>) -> Range<String.Index>? {
        tokenizer.string = string
        let semaphore = DispatchSemaphore(value: 0)
        var keywordRange: Range<String.Index>?
        tokenizer.enumerateTokens(in: range) { tokenRange, _ in
            let token = String(string[tokenRange])
            if keywords.contains(token) {
                keywordRange = tokenRange
                semaphore.signal()
                return false
            } else if tokenRange.upperBound == range.upperBound {
                semaphore.signal()
                return false
            } else {
                return true
            }
        }
        semaphore.wait()
        return keywordRange
    }
}
