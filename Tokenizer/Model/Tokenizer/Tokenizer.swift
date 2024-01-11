//
//  Tokenizer.swift
//  Tokenizer
//
//  Created by Somebody on 10/01/2024.
//

import Foundation

protocol KeywordRangeSearching {
    func setLanguage(language: Language)
    func keywordRange(in string: String, inRange range: Range<String.Index>, keywords: Set<String>) -> Range<String.Index>?
}

struct Tokenizer {
    
    // MARK: - Properties
    
    let keywordRangeSearcher: KeywordRangeSearching
    
    // MARK: - Init
    
    init(keywordRangeSearcher: KeywordRangeSearching) {
        self.keywordRangeSearcher = keywordRangeSearcher
    }
    
    // MARK: - Methods
    
    func tokenize(string: String, language: Language) -> [String] {
        let keywordRanges = keywordRanges(in: string, language: language)
        return mapToSentences(string: string, keywordRanges: keywordRanges)
    }
    
    // MARK: - Private methods
    
    private func keywordRanges(in string: String, language: Language) -> [Range<String.Index>] {
        var startIndex: String.Index?
        var keywordRanges: [Range<String.Index>] = []
        repeat {
            let lowerBound = startIndex ?? string.startIndex
            if let keywordRange = keywordRangeSearcher.keywordRange(in: string, inRange: lowerBound..<string.endIndex, keywords: language.tokenizationKeywords) {
                keywordRanges.append(keywordRange)
                startIndex = keywordRange.upperBound
                if keywordRange.upperBound == string.endIndex {
                    startIndex = nil
                }
            } else {
                startIndex = nil
            }
        } while startIndex != nil
        
        return keywordRanges
    }
    
    private func mapToSentences(string: String, keywordRanges: [Range<String.Index>]) -> [String] {
        if keywordRanges.isEmpty {
            print([string])
            return [string.firstCapitalized]
        } else {
            var lowerBound = string.startIndex
            var sentences = keywordRanges
                .map { range in
                    let sentence = String(string[lowerBound..<range.lowerBound]).firstCapitalized
                    lowerBound = range.lowerBound
                    return sentence
                }
            if let lastRange = keywordRanges.last {
                let sentence = String(string[lastRange.lowerBound..<string.endIndex]).firstCapitalized
                sentences.append(sentence)
            }
            print(sentences)
            return sentences
        }
    }
}
