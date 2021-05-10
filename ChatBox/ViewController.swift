//
//  ViewController.swift
//  ChatBox
//
//  Created by Nishant Taneja on 10/05/21.
//

import UIKit

class FirstController: UIViewController {
    override func loadView() {
        super.loadView()
        title = "Chats"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.pushViewController(ViewController(), animated: true)
    }
}

class ViewController: UIViewController {
    // Constants
    private let heightForChatInputView: CGFloat = 48
    
    // Views
    private let backgroundImageView: UIImageView = {
        let image = UIImage(named: "background")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
    private lazy var chatInfoView: ChatInfoView = {
        let view = ChatInfoView()
        view.frame.size.width = self.view.frame.width - 100
        view.frame.size.height = navigationController?.navigationBar.frame.height ?? 10
        return view
    }()
    
    // Constraints
    private var constraintsToActivate: [NSLayoutConstraint] {[
        // Background Image View
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top),
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.safeAreaInsets.left),
        backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.safeAreaInsets.right),
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.safeAreaInsets.bottom),
    ]}
    
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
        view.addSubview(chatInputView)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        NSLayoutConstraint.activate(constraintsToActivate)
        chatInputView.frame.origin.y = view.frame.height - view.safeAreaInsets.bottom - chatInputView.frame.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = chatInfoView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillChangeFrame(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
