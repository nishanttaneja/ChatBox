//
//  ChatInputView.swift
//  ChatBox
//
//  Created by Nishant Taneja on 10/05/21.
//

import UIKit

//MARK:- ActionType
@objc enum ChatInputViewActionType: Int {
    case addAttachment, startAudioRecording, sendMessage
    
    var image: UIImage? {
        var image: UIImage?
        switch self {
        case .addAttachment: image = UIImage(systemName: "plus")
        case .sendMessage: image = UIImage(systemName: "paperplane.fill")?.applyingSymbolConfiguration(.init(scale: .large))
        case .startAudioRecording: image = UIImage(systemName: "mic")
        }
        return image
    }
}

//MARK:- Delegate
@objc protocol ChatInputViewDelegate: AnyObject {
    @objc optional func chatInputView(_ view: ChatInputView, didSelectIconFor actionType: ChatInputViewActionType)
}

//MARK:- DelegateLayout
@objc protocol ChatInputViewDelegateLayout: AnyObject {
    @objc optional func spacingForItems(in chatInputView: ChatInputView) -> CGFloat
}

//MARK:- ChatInputView
class ChatInputView: UIView, UITextViewDelegate {
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
        textView.font = .systemFont(ofSize: 14)
        textView.textContainer.lineFragmentPadding = 8
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
    
    // UITextView Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        microphoneAndMessageButton.setImage(ChatInputViewActionType.sendMessage.image, for: .normal)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        microphoneAndMessageButton.setImage(ChatInputViewActionType.startAudioRecording.image, for: .normal)
    }
    func textViewDidChange(_ textView: UITextView) {
        let oldHeight = frame.size.height
        if textView.contentSize.height > 48 {
            let newHeight = textView.contentSize.height + 2*padding
            frame.size.height = newHeight
            frame.origin.y -= newHeight - oldHeight
        } else if frame.height > 48 {
            frame.size.height = 48
            frame.origin.y -= 48 - oldHeight
        }
    }
    
    // Constraints
    private var constraintsToActivate: [NSLayoutConstraint] {
        [
            // Input Text View
            inputTextView.leftAnchor.constraint(equalTo: attachmentsButton.rightAnchor, constant: spacing),
            inputTextView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            inputTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            // Attachment Button
            attachmentsButton.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
            attachmentsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1.5*padding),
            attachmentsButton.widthAnchor.constraint(equalToConstant: 24),
            // Microphone Button
            microphoneAndMessageButton.leftAnchor.constraint(equalTo: inputTextView.rightAnchor, constant: spacing),
            microphoneAndMessageButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding),
            microphoneAndMessageButton.widthAnchor.constraint(equalToConstant: 24),
            microphoneAndMessageButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1.5*padding)
        ]
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
        inputTextView.layer.cornerRadius = (attachmentsButton.frame.height + 2*padding)/2
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        NSLayoutConstraint.activate(constraintsToActivate)
    }
}
