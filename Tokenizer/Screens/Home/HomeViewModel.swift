//
//  HomeViewModel.swift
//  Tokenizer
//
//  Created by Somebody on 10/01/2024.
//

import Combine

final class HomeViewModel: ObservableObject {
    
    // MARK: - Inputs
    
    @Published var input: String = ""
    @Published var selectedLanguageIndex = 0
    
    // MARK: - Outputs
    
    @Published private(set) var languages: [Language] = Language.allCases
    @Published private(set) var output: String = ""
    var clearInputPublisher: AnyPublisher<Void, Never> {
        clearInputSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Properties
    
    private let clearInputSubject = PassthroughSubject<Void, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        $input
            .dropFirst()
            .sink { [weak self] input in
                guard let self else { return }
                output = input
            }
            .store(in: &subscriptions)
        
        $selectedLanguageIndex
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] index in
                guard let self else { return }
                clearInputSubject.send()
            }
            .store(in: &subscriptions)
    }
}
