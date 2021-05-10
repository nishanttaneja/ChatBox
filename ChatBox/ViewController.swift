//
//  ViewController.swift
//  ChatBox
//
//  Created by Nishant Taneja on 10/05/21.
//

import UIKit

class ViewController: UIViewController {
    // Constants
    private let heightForChatInputView: CGFloat = 80
    
    // Views
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .blue // ImageView's BackgroundColor
        return imageView
    }()
    private lazy var chatInputView: ChatInputView = {
        let view = ChatInputView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = self.view.backgroundColor
        view.delegate = self
        return view
    }()
    
    // Constraints
    private var constraintsToActivate: [NSLayoutConstraint] {[
        // Background Image View
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top),
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.safeAreaInsets.left),
        backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.safeAreaInsets.right),
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.safeAreaInsets.bottom),
        // Chat Input View
        chatInputView.leftAnchor.constraint(equalTo: view.leftAnchor),
        chatInputView.rightAnchor.constraint(equalTo: view.rightAnchor),
        chatInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ]}
    
    // LifeCycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemGray5
        view.addSubview(backgroundImageView)
        view.addSubview(chatInputView)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        NSLayoutConstraint.activate(constraintsToActivate)
    }
}

extension ViewController: ChatInputViewDelegateLayout {
    func padding(for chatInputView: ChatInputView) -> CGFloat {
        8
    }
    
    func spacingForItems(in chatInputView: ChatInputView) -> CGFloat {
        8
    }
}

@objc protocol ChatInputViewDelegateLayout: AnyObject {
    @objc optional func padding(for chatInputView: ChatInputView) -> CGFloat
    @objc optional func spacingForItems(in chatInputView: ChatInputView) -> CGFloat
}

class ChatInputView: UIView {
    // Delegates
    weak var delegate: ChatInputViewDelegateLayout? {
        didSet {
            inputViewPadding = delegate?.padding?(for: self) ?? inputViewPadding
            spacingForInputViewItems = delegate?.spacingForItems?(in: self) ?? spacingForInputViewItems
        }
    }
    
    // Constants
    private var inputViewPadding: CGFloat = 8
    private var spacingForInputViewItems: CGFloat = 8
    
    // SubViews
    private let viewForInputs: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let inputTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .white
        textView.font = .systemFont(ofSize: 16)
        textView.textContainer.lineFragmentPadding = 10
        textView.textColor = .black
        return textView
    }()
    private lazy var attachmentsButton: UIButton = {
        button(with: UIImage(systemName: "plus"))
    }()
    private lazy var cameraButton: UIButton = {
        button(with: UIImage(systemName: "camera"))
    }()
    private lazy var microphoneButton: UIButton = {
        button(with: UIImage(systemName: "mic"))
    }()
    
    private func button(with image: UIImage?) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = image?.withTintColor(.green, renderingMode: .alwaysOriginal).applyingSymbolConfiguration(.init(pointSize: 20))
        button.setImage(image, for: .normal)
        return button
    }
    
    // Constraints
    private var constraintsToActivate: [NSLayoutConstraint] {
        [
            // View For Inputs
            viewForInputs.topAnchor.constraint(equalTo: topAnchor, constant: inputViewPadding),
            viewForInputs.leftAnchor.constraint(equalTo: leftAnchor, constant: inputViewPadding),
            viewForInputs.rightAnchor.constraint(equalTo: rightAnchor, constant: -inputViewPadding),
            viewForInputs.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -inputViewPadding),
            // Attachment Button
            attachmentsButton.leftAnchor.constraint(equalTo: viewForInputs.leftAnchor),
            // Input Text View
            inputTextView.leftAnchor.constraint(equalTo: attachmentsButton.rightAnchor, constant: spacingForInputViewItems),
            // Camera Button
            cameraButton.leftAnchor.constraint(equalTo: inputTextView.rightAnchor, constant: spacingForInputViewItems),
            // Microphone Button
            microphoneButton.leftAnchor.constraint(equalTo: cameraButton.rightAnchor, constant: spacingForInputViewItems),
            microphoneButton.rightAnchor.constraint(equalTo: viewForInputs.rightAnchor),
        ] + topBottomConstraints(on: viewForInputs, for: attachmentsButton, inputTextView, cameraButton, microphoneButton)
    }
    
    private func topBottomConstraints(on view: UIView, for views: UIView...) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        for v in views {
            constraints.append(contentsOf: [
                v.topAnchor.constraint(equalTo: view.topAnchor),
                v.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        return constraints
    }
    
    // Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(viewForInputs)
        viewForInputs.addSubview(attachmentsButton)
        viewForInputs.addSubview(inputTextView)
        viewForInputs.addSubview(cameraButton)
        viewForInputs.addSubview(microphoneButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
        inputTextView.layer.cornerRadius = viewForInputs.frame.height/3
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        NSLayoutConstraint.activate(constraintsToActivate)
    }
}
