//
//  BaseCreateMessageViewController.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 01.04.2024.
//

import UIKit
import Combine

class BaseCreateMessageViewController: NiblessViewController {
    
    // MARK: - Properties
    // State
    var subscriptions = Set<AnyCancellable>()
    
    // View Model
    let viewModel: BaseCreateMessageViewModel
    
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        return makeBarButtonItem(title: L.CreateMessageScreen.closeBarButton.localized,
                                 selector: #selector(BaseCreateMessageViewModel.close))
    }()

    private lazy var sendBarButtonItem: UIBarButtonItem = {
        return makeBarButtonItem(title: L.CreateMessageScreen.sendBarButton.localized,
                                 selector: #selector(BaseCreateMessageViewModel.send))
    }()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    // MARK: - Initialization
    
    init(viewModel: BaseCreateMessageViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupGestures()
        observeViewModel()
    }
    
    func showImagePicker() {
        present(imagePickerController, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func observeViewModel() {
        viewModel.errorMessages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                guard let self = self else { return }
                self.presentAlert(title: alert.title, message: alert.message)
            }.store(in: &subscriptions)
        
        viewModel.showImagePicker
            .sink { [weak self] in
                guard let self = self else { return }
                self.showImagePicker()
            }
            .store(in: &subscriptions)
        
        viewModel.$sendButtonIsEnabled
            .assign(to: \.isEnabled, on: sendBarButtonItem)
            .store(in: &subscriptions)
    }
    
    private func setupNavigationItem() {
        self.navigationItem.leftBarButtonItem = closeBarButtonItem
        self.navigationItem.rightBarButtonItem = sendBarButtonItem
    }
    
    private func makeBarButtonItem(title: String, selector: Selector) -> UIBarButtonItem {
        let item = UIBarButtonItem(title: title, style: .plain, target: viewModel, action: selector)
        item.tintColor = #colorLiteral(red: 0.9176470588, green: 0.4, blue: 0, alpha: 1)
        return item
    }
}

// MARK: - UIImagePickerControllerDelegate
extension BaseCreateMessageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            (view as! BaseCreateMessageRootView).insertPhotoAttachment(photo: image)
            
            picker.dismiss(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - Gesture
extension BaseCreateMessageViewController {
    
    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
