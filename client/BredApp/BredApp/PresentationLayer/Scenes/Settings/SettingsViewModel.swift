//
//  SettingsViewModel.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 24.03.2024.
//

import Foundation
import Combine

protocol SettingsFlowDelegate {
    func didTapSignOutRow()
}

class SettingsViewModel {
    
    enum TableRow: Int {
        case signOut
    }
    
    // MARK: - Properties
    
    private let delegate: SettingsFlowDelegate
    private let signOutUseCaseFactory: SignOutUseCaseFactory
    
    private var rows: [SettingsCellModel] {
        return [
            SettingsCellModel(optionName: L.SettingsScreen.signOutRow.localized, color: .systemRed)
        ]
    }
    
    var errorMessages: AnyPublisher<AlertMessage, Never> {
        errorMessagesSubject.eraseToAnyPublisher()
    }
    private let errorMessagesSubject = PassthroughSubject<AlertMessage, Never>()
    
    // MARK: - Initialization
    
    init(delegate: SettingsFlowDelegate, signOutUseCaseFactory: SignOutUseCaseFactory) {
        self.delegate = delegate
        self.signOutUseCaseFactory = signOutUseCaseFactory
    }
    
    // MARK: - Methods
    
    func numberOfRowsInSection() -> Int {
        return rows.count
    }
    
    func getCellModel(for index: Int) -> SettingsCellModel {
        return rows[index]
    }
    
    func didSelectRowAt(index: Int) {
        guard let row = TableRow(rawValue: index) else { return }
        
        switch row {
        case .signOut:
            signOut()
            delegate.didTapSignOutRow()
        }
    }
    
    // MARK: - Private Methods
    
    private func signOut() {
        do {
            let useCase = signOutUseCaseFactory.makeSignOutUseCase()
            try useCase.start()
        } catch {
            handleSignOutFailure(error: error)
        }
    }
    
    private func handleSignOutFailure(error: Error) {
        let message = AlertMessage(title: L.ErrorMessage.title.localized,
                                   message: error.localizedDescription)
        errorMessagesSubject.send(message)
    }
}
