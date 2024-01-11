//
//  Tokenizer.swift
//  Tokenizer
//
//  Created by Somebody on 10/01/2024.
//

import Foundation
import NaturalLanguage

final class Tokenizer {
    
    // MARK: - Properties
    
    private lazy var tokenizer = NLTokenizer(unit: .word)

    
    // MARK: - Methods
    
    func tokenize(string: String, language: Language) -> [String] {
        var string = string.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .punctuationCharacters)
        tokenizer.setLanguage(NLLanguage(language: language))
        tokenizer.string = string
        let keywordRanges = keywordRanges(in: string, keywords: language.tokenizationKeywords)
        return mapToSentences(string: string, keywordRanges: keywordRanges)
    }
    
    // MARK: - Private methods
    
    private func keywordRanges(in string: String, keywords: Set<String>) -> [Range<String.Index>] {
        var startIndex: String.Index?
        var keywordRanges: [Range<String.Index>] = []
        repeat {
            let lowerBound = startIndex ?? string.startIndex
            if let keywordRange = keywordRange(in: lowerBound..<string.endIndex, keywords: keywords) {
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
    
    private func keywordRange(in range: Range<String.Index>, keywords: Set<String>) -> Range<String.Index>? {
        guard let string = tokenizer.string else { return nil }
        let semaphore = DispatchSemaphore(value: 0)
        var keywordRange: Range<String.Index>?
        tokenizer.enumerateTokens(in: range) { tokenRange, _ in
            let token = String(string[tokenRange])
            if keywords.contains(where: { $0.caseInsensitiveCompare(token) == .orderedSame }) {
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
