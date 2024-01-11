//
//  StringProtocol+Helpers.swift
//  Tokenizer
//
//  Created by Somebody on 11/01/2024.
//

import Foundation

extension StringProtocol {
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}
