//
//  FeedbackViewController.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/26/23.
//

import Foundation
import UIKit

protocol FeedbackViewControllerProtocol: AnyObject {
    func feedbackSubmitted()
}

class FeedbackViewController: UIViewController, UITextViewDelegate, FeedbackViewControllerProtocol {
    
    var eventHandler: FeedbackEventHandlerProtocol
    
    private var recommend: Bool? = nil
    
    private lazy var thumbsUpButton: UIButton = {
        let button = createButton(imageName: "hand.thumbsup.circle")
        button.addTarget(self, action: #selector(thumbsUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var thumbsDownButton: UIButton = {
        let button = createButton(imageName: "hand.thumbsdown.circle")
        button.addTarget(self, action: #selector(thumbsDownButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentsTextView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 8.0
        return textView
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setImage(UIImage(systemName: "paperplane.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var thankYouLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Thank you for your feedback!"
        label.isHidden = true
        return label
    }()

    
    init(eventHandler: FeedbackEventHandlerProtocol) {
        self.eventHandler = eventHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "What do you think of our app?"
        
        self.feedbackSetup()
    }
    
    func feedbackSetup() {
        self.view.addSubview(thumbsUpButton)
        self.view.addSubview(thumbsDownButton)
        self.view.addSubview(commentsTextView)
        self.view.addSubview(submitButton)
        self.view.addSubview(thankYouLabel)
        
        thumbsUpButton.translatesAutoresizingMaskIntoConstraints = false
        thumbsDownButton.translatesAutoresizingMaskIntoConstraints = false
        commentsTextView.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        thankYouLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thumbsUpButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -50),
            thumbsUpButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            
            thumbsDownButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 50),
            thumbsDownButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            
            commentsTextView.topAnchor.constraint(equalTo: thumbsUpButton.bottomAnchor, constant: 20),
            commentsTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            commentsTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            commentsTextView.heightAnchor.constraint(equalToConstant: 200),
            
            submitButton.topAnchor.constraint(equalTo: commentsTextView.bottomAnchor, constant: 20),
            submitButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            
            thankYouLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            thankYouLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)

        ])
    }
    
    @objc func thumbsUpButtonTapped() {
        recommend = true
        thumbsUpButton.tintColor = .systemGreen
        thumbsDownButton.tintColor = .systemBlue
    }
    
    @objc func thumbsDownButtonTapped() {
        recommend = false
        thumbsDownButton.tintColor = .systemRed
        thumbsUpButton.tintColor = .systemBlue
    }
    
    @objc func submitButtonTapped() {
        guard let recommend = recommend, let comments = commentsTextView.text, comments.count <= 500, comments.count > 0 else {
            showInputErrorAlert()
            return
        }
        
        let feedbackData = FeedbackData(recommend: recommend, comments: comments)
        eventHandler.sendFeedback(data: feedbackData)
    }
    
    func feedbackSubmitted() {
        
        thumbsUpButton.isHidden = true
        thumbsDownButton.isHidden = true
        commentsTextView.isHidden = true
        submitButton.isHidden = true
        
        thankYouLabel.isHidden = false
    }
    
    private func createButton(imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: imageName), for: .normal)
        return button
    }
    
    private func showInputErrorAlert() {
        let alert = UIAlertController(title: "Input Error", message: "Please ensure all fields are filled and comments do not exceed 500 characters.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
