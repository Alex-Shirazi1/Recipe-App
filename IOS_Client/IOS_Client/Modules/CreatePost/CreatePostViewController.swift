//
//  CreatePostViewController.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/28/23.
//

import Foundation
import UIKit


protocol CreatePostViewControllerProtocol: AnyObject {
    func showErrorAlert(error: Error)
}

class CreatePostViewController: UIViewController, CreatePostViewControllerProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let eventHandler: CreatePostEventHandlerProtocol
    
    private let titleField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Title"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let descriptionField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Description"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let imageView: UIImageView = {
         let imageView = UIImageView()
         imageView.contentMode = .center
         imageView.isUserInteractionEnabled = true
         imageView.layer.borderColor = UIColor.gray.cgColor
         imageView.layer.borderWidth = 1
         imageView.image = UIImage(systemName: "camera.fill")?.withTintColor(.gray)
         imageView.translatesAutoresizingMaskIntoConstraints = false
         return imageView
     }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(eventHandler: CreatePostEventHandlerProtocol) {
        self.eventHandler = eventHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
    }
    
    private func setup() {
        view.addSubview(titleField)
        view.addSubview(descriptionField)
        view.addSubview(imageView)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 20),
            descriptionField.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
            descriptionField.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: descriptionField.bottomAnchor, constant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.leadingAnchor.constraint(equalTo: descriptionField.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: descriptionField.trailingAnchor),
            
            submitButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapSubmitButton() {
        guard let title = titleField.text, !title.isEmpty,
              let description = descriptionField.text, !description.isEmpty,
              let image = imageView.image else {
            print("Please fill all fields and select an image")
            return
        }
        
        eventHandler.createPost(title: title, body: description, image: image)
    }
    
    @objc func didTapImageView() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self?.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self?.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = selectedImage
        imageView.contentMode = .scaleAspectFit
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func showErrorAlert(error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
