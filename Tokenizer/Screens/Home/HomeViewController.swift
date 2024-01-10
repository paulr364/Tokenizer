//
//  HomeViewController.swift
//  Tokenizer
//
//  Created by Somebody on 10/01/2024.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var languagePicker: UIPickerView!
    @IBOutlet private var inputField: UITextField!
    @IBOutlet private var outputLabel: UILabel!
    
    // MARK: - Properties
    
    private var subscriptions = Set<AnyCancellable>()
    var viewModel: HomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        languagePicker.dataSource = self
        languagePicker.delegate = self
    }
    
    private func setupBindings() {
        let textFieldPublisher = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: inputField)
            .map { ($0.object as? UITextField)?.text ?? "" }
                
        textFieldPublisher
            .assign(to: \.input, on: viewModel)
            .store(in: &subscriptions)
        
        viewModel.$output
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .assign(to: \.text, on: outputLabel)
            .store(in: &subscriptions)
        
        viewModel.clearInputPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                inputField.text = nil
                viewModel.input = ""
            }
            .store(in: &subscriptions)
    }
}

// MARK: - HomeViewController + UIPickerViewDataSource

extension HomeViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.languages.count
    }
}

// MARK: - HomeViewController + UIPickerViewDelegate

extension HomeViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel.languages[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectedLanguageIndex = row
    }
}
