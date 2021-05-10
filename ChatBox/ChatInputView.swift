//
//  ChatInputView.swift
//  ChatBox
//
//  Created by Nishant Taneja on 10/05/21.
//

import UIKit

@objc enum ChatInputViewActionType: Int {
    case addAttachment, startAudioRecording, sendMessage
    
    var image: UIImage? {
        var image: UIImage?
        switch self {
        case .addAttachment: image = UIImage(systemName: "plus")
        case .sendMessage: image = UIImage(systemName: "arrow.right.circle.fill")
        case .startAudioRecording: image = UIImage(systemName: "mic")
        }
        image = image?.withTintColor(.green, renderingMode: .alwaysOriginal).applyingSymbolConfiguration(.init(pointSize: 16))
        return image
    }
}

@objc protocol ChatInputViewDelegate: AnyObject {
    @objc optional func chatInputView(_ view: ChatInputView, didSelectIconFor actionType: ChatInputViewActionType)
}

@objc protocol ChatInputViewDelegateLayout: AnyObject {
    @objc optional func spacingForItems(in chatInputView: ChatInputView) -> CGFloat
}

class ChatInputView: UIView {
    // Delegates
    weak var delegate: ChatInputViewDelegate?
    weak var delegateLayout: ChatInputViewDelegateLayout? {
        didSet {
            spacing = delegateLayout?.spacingForItems?(in: self) ?? spacing
        }
    }
    
    // Constants
    private var padding: CGFloat = 8
    private var spacing: CGFloat = 8
    
    // SubViews
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
        button(for: .addAttachment)
    }()
    private lazy var microphoneAndMessageButton: UIButton = {
        button(for: .startAudioRecording)
    }()

    private func button(for actionType: ChatInputViewActionType) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        switch actionType {
        case .addAttachment: button.tag = 0
        case .startAudioRecording, .sendMessage: button.tag = 1
        }
        button.addTarget(self, action: #selector(handleButtonAction(for:)), for: .touchUpInside)
        button.setImage(actionType.image, for: .normal)
        return button
    }
    
    @objc private func handleButtonAction(for button: UIButton) {
        let actionType: ChatInputViewActionType = button.tag == 0 ? .addAttachment : (button.currentImage == ChatInputViewActionType.startAudioRecording.image ? .startAudioRecording : .sendMessage)
        delegate?.chatInputView?(self, didSelectIconFor: actionType)
    }
    
    // Constraints
    private var constraintsToActivate: [NSLayoutConstraint] {
        [
            // Attachment Button
            attachmentsButton.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
            // Input Text View
            inputTextView.leftAnchor.constraint(equalTo: attachmentsButton.rightAnchor, constant: spacing),
            // Microphone Button
            microphoneAndMessageButton.leftAnchor.constraint(equalTo: inputTextView.rightAnchor, constant: spacing),
            microphoneAndMessageButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding),
            microphoneAndMessageButton.widthAnchor.constraint(equalTo: attachmentsButton.widthAnchor)
        ] + topBottomConstraints(for: attachmentsButton, inputTextView, microphoneAndMessageButton)
    }
    
    private func topBottomConstraints(for views: UIView...) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        for view in views {
            constraints.append(contentsOf: [
                view.topAnchor.constraint(equalTo: topAnchor, constant: padding),
                view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
            ])
        }
        return constraints
    }
        
    // Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(attachmentsButton)
        addSubview(inputTextView)
        addSubview(microphoneAndMessageButton)
        inputTextView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
        inputTextView.layer.cornerRadius = inputTextView.frame.height/2
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        NSLayoutConstraint.activate(constraintsToActivate)
    }
}

extension ChatInputView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        microphoneAndMessageButton.setImage(ChatInputViewActionType.sendMessage.image, for: .normal)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        microphoneAndMessageButton.setImage(ChatInputViewActionType.startAudioRecording.image, for: .normal)
    }
}
