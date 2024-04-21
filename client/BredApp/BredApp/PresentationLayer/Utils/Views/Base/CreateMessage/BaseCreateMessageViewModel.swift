//
//  CreateMessageViewModel.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 01.04.2024.
//

import Foundation
import UIKit
import Combine

class BaseCreateMessageViewModel {
    
    // MARK: - Properties
    
    private var photo: [UIImage] = []
    
    // Input fields
    var messageText = ""
        
    // Publishers
    var showImagePicker: AnyPublisher<Void, Never> {
        showImagePickerSubject.eraseToAnyPublisher()
    }
    private let showImagePickerSubject = PassthroughSubject<Void, Never>()
    
    var errorMessages: AnyPublisher<AlertMessage, Never> {
        errorMessagesSubject.eraseToAnyPublisher()
    }
    private let errorMessagesSubject = PassthroughSubject<AlertMessage, Never>()
    
    @Published var sendButtonIsEnabled = true
    @Published var activityIndicatorAnimating = false
    
    // MARK: - Methods
    
    func numberOfItemsInSection() -> Int {
        self.photo.count
    }
    
    func getPhotoPreviewCellModel(for index: Int) -> PhotoPreviewCellModel? {
        guard let data = photo[index].jpegData(compressionQuality: 1.0) else {
            return nil
        }
        
        return PhotoPreviewCellModel(image: photo[index],
                                     sizeInMB: getSizeInMB(data: data))
    }
    
    func insertPhotoAttachment(photo: UIImage) {
        self.photo.append(photo)
    }
    
    func deletePhotoAttachment(at index: Int) {
        self.photo.remove(at: index)
    }
    
    func getSizeInMB(data: Data) -> String {
        let sizeInMB = Float(data.count) / 1024.0 / 1024.0
        return String(format: "%.1fМБ", sizeInMB)
    }
    
    func convertPhotosToAttachments() -> [Attachment] {
        photo.compactMap {
            guard let data = $0.jpegData(compressionQuality: 1.0) else {
                return nil
            }
            return Attachment(type: .photo(format: .jpg), data: data)
        }
    }
    
    @objc
    func send() {
        assertionFailure("send() method must be overridden in subclass")
    }
    
    @objc
    func close() {
        assertionFailure("close() method must be overridden in subclass")
    }
    
    @objc
    func addAttachments() {
        showImagePickerSubject.send()
    }
    
    func sendErrorMessage(_ message: String) {
        let message = AlertMessage(title: L.ErrorMessage.title.localized,
                                   message: message)
        errorMessagesSubject.send(message)
    }
    
    func indicateProcessing() {
        sendButtonIsEnabled = false
        activityIndicatorAnimating = true
    }
    
    func indicateFinishProcessing() {
        sendButtonIsEnabled = true
        activityIndicatorAnimating = false
    }
}
