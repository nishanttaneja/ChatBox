//
//  ViewController.swift
//  ChatBox
//
//  Created by Nishant Taneja on 10/05/21.
//

import UIKit

class ViewController: UIViewController {
    // Constants
    private let heightForChatInputView: CGFloat = 48
    
    // Views
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .blue // ImageView's BackgroundColor
        return imageView
    }()
    private lazy var chatInputView: ChatInputView = {
        let view = ChatInputView()
        view.frame.size = .init(width: self.view.frame.width, height: heightForChatInputView)
        view.frame.origin = .init(x: 0, y: self.view.frame.height - self.view.safeAreaInsets.bottom - view.frame.height)
        view.backgroundColor = self.view.backgroundColor
        view.delegateLayout = self
        view.delegate = self
        return view
    }()
    
    // Properties
    private var backgroundImage: UIImage? {
        get { backgroundImageView.image }
        set { backgroundImageView.image = newValue }
    }
    
    // LifeCycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemGray5
        view.addSubview(backgroundImageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addSubview(chatInputView)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillChangeFrame(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        NSLayoutConstraint.activate([
            // Background Image View
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top),
            backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.safeAreaInsets.left),
            backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.safeAreaInsets.right),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.safeAreaInsets.bottom),
        ])
    }
    
    // Interaction
    @objc func handleKeyboardWillChangeFrame(notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            print("unable to change frame of ChatInputView")
            return
        }
        let defaultOriginY: CGFloat = view.frame.height - view.safeAreaInsets.bottom - chatInputView.frame.height
        if chatInputView.frame.origin.y != defaultOriginY { chatInputView.frame.origin.y = defaultOriginY }
        else { chatInputView.frame.origin.y = frame.origin.y - chatInputView.frame.height }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK:- ChatInputView
extension ViewController: ChatInputViewDelegate, ChatInputViewDelegateLayout {
    // Delegate
    func chatInputView(_ view: ChatInputView, didSelectIconFor actionType: ChatInputViewActionType) {
        print(#function, actionType.rawValue)
    }
    
    // Delegate Layout
    func spacingForItems(in chatInputView: ChatInputView) -> CGFloat {
        8
    }
}
