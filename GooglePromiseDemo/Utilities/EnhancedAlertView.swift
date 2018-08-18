//
//  EnhancedAlertView.swift
//  ast-v2
//
//  Created by James Hall on 6/9/18.
//  Copyright © 2018 JTH. All rights reserved.
//

import UIKit

@objc open class EnhancedAlertView: UIViewController {
    
    public enum AlertType: Int {
        case alert
        case confirmation
        case multipleChoice
    }
    
    public enum ShowAnimation: Int {
        case fadeIn
        case flyLeft
        case flyTop
        case flyRight
        case flyBottom
        case bounceLeft
        case bounceRight
        case bounceBottom
        case bounceTop
    }
    
    public enum HideAnimation: Int {
        case fadeOut
        case flyLeft
        case flyTop
        case flyRight
        case flyBottom
        case bounceLeft
        case bounceRight
        case bounceBottom
        case bounceTop
        
    }
    
    public typealias TouchHandler = (EnhancedAlertView) -> ()
    
    static let Padding: CGFloat               = 12
    static let InnerPadding: CGFloat          = 8
    static let CornerRadius: CGFloat          = 4
    static let ButtonHeight: CGFloat          = 40
    static let ButtonSectionExtraGap: CGFloat = 12
    static let TextFieldHeight: CGFloat       = 40
    static let AlertWidth: CGFloat            = 280
    static let AlertHeight: CGFloat           = 65
    static let BackgroundAlpha: CGFloat       = 0.5
    
    // MARK: - Global
    public static var padding: CGFloat               = EnhancedAlertView.Padding
    public static var innerPadding: CGFloat          = EnhancedAlertView.InnerPadding
    public static var cornerRadius: CGFloat          = EnhancedAlertView.CornerRadius
    public static var buttonHeight: CGFloat          = EnhancedAlertView.ButtonHeight
    public static var buttonSectionExtraGap: CGFloat = EnhancedAlertView.ButtonSectionExtraGap
    public static var textFieldHeight: CGFloat       = EnhancedAlertView.TextFieldHeight
    public static var backgroundAlpha: CGFloat       = EnhancedAlertView.BackgroundAlpha
    public static var blurredBackground: Bool        = false
    public static var showAnimation: ShowAnimation   = .fadeIn
    public static var hideAnimation: HideAnimation   = .fadeOut
    public static var duration:CGFloat               = 0.3
    public static var initialSpringVelocity:CGFloat  = 0.5
    public static var damping:CGFloat                = 0.5
    public static var statusBarStyle: UIStatusBarStyle?
    
    
    // Font
    public static var alertTitleFont: UIFont?
    public static var messageFont: UIFont?
    public static var buttonFont: UIFont?
    
    // Color
    public static var positiveColor: UIColor?            = UIColor(red:0.09, green:0.47, blue:0.24, alpha:1.0)
    public static var negativeColor: UIColor?            = UIColor(red:0.91, green:0.3, blue:0.24, alpha:1.0)
    public static var neutralColor: UIColor?             = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.0)
    public static var titleColor: UIColor?               = UIColor(red:0.5, green:0.55, blue:0.55, alpha:1.0)
    public static var buttonTitleColor: UIColor?         = UIColor.white
    public static var messageColor: UIColor?             = UIColor(red:0.5, green:0.55, blue:0.55, alpha:1.0)
    public static var cancelTextColor: UIColor?          = UIColor(red:0.5, green:0.55, blue:0.55, alpha:1.0)
    public static var normalTextColor: UIColor?          = UIColor.white
    public static var textFieldTextColor: UIColor?       = UIColor(red:0.5, green:0.55, blue:0.55, alpha:1.0)
    public static var textFieldBorderColor: UIColor?     = UIColor(red:0.5, green:0.55, blue:0.55, alpha:1.0)
    public static var textFieldBackgroundColor: UIColor? = UIColor.white
    
    // MARK: -
    open var alertType: AlertType = AlertType.alert
    open var alertTitle: String?
    open var message: String?
    open var messageAttributedString: NSAttributedString?
    
    open var okTitle: String? {
        didSet {
            btnOk.setTitle(okTitle, for: UIControlState())
        }
    }
    
    open var cancelTitle: String? {
        didSet {
            btnCancel.setTitle(cancelTitle, for: UIControlState())
        }
    }
    
    open var closeTitle: String? {
        didSet {
            btnClose.setTitle(closeTitle, for: UIControlState())
        }
    }
    
    open var allowTouchOutsideToDismiss: Bool = true {
        didSet {
            weak var weakSelf = self
            if weakSelf != nil {
                if allowTouchOutsideToDismiss == false {
                    weakSelf!.tapOutsideTouchGestureRecognizer.removeTarget(weakSelf!, action: #selector(EnhancedAlertView.dismissAlertView))
                }
                else {
                    weakSelf!.tapOutsideTouchGestureRecognizer.addTarget(weakSelf!, action: #selector(EnhancedAlertView.dismissAlertView))
                }
            }
        }
    }
    fileprivate var tapOutsideTouchGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    open var isOkButtonLeft: Bool = false
    open var width: CGFloat = EnhancedAlertView.AlertWidth
    open var height: CGFloat = EnhancedAlertView.AlertHeight
    
    // Master views
    open var backgroundView: UIView!
    open var alertView: UIView!
    
    // View components
    var lbTitle: UILabel!
    var lbMessage: UILabel!
    var btnOk: ZButton!
    var btnCancel: ZButton!
    var btnClose: ZButton!
    var buttons: [ZButton] = []
    var textFields: [ZTextField] = []
    
    // Handlers
    open var cancelHandler: TouchHandler? = { alertView in
        alertView.dismissAlertView()
        }{
        didSet {
            btnCancel.touchHandler = cancelHandler
        }
    }
    
    open var okHandler: TouchHandler? {
        didSet {
            btnOk.touchHandler = okHandler
        }
    }
    
    open var closeHandler: TouchHandler? {
        didSet {
            btnClose.touchHandler = closeHandler
        }
    }
    
    // Windows
    var previousWindow: UIWindow!
    var alertWindow: UIWindow!
    
    // Old frame
    var oldFrame: CGRect!
    
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.setupViews()
        self.setupWindow()
    }
    
    public init(title: String?, message: String?, alertType: AlertType) {
        super.init(nibName: nil, bundle: nil)
        self.setupViews()
        self.setupWindow()
        self.alertTitle = title
        self.alertType = alertType
        self.message = message
    }
    
    public convenience init(title: String?, message: String?, closeButtonText: String?, closeButtonHandler: TouchHandler?) {
        self.init(title: title, message: message, alertType: AlertType.alert)
        self.closeTitle = closeButtonText
        btnClose.setTitle(closeTitle, for: UIControlState())
        self.closeHandler = closeButtonHandler
        self.btnClose.touchHandler = self.closeHandler
    }
    
    public convenience init(title: String?, message: String?, okButtonText: String?, cancelButtonText: String?) {
        self.init(title: title, message: message, alertType: AlertType.confirmation)
        self.okTitle = okButtonText
        self.btnOk.setTitle(okTitle, for: UIControlState())
        self.cancelTitle = cancelButtonText
        self.btnCancel.setTitle(cancelTitle, for: UIControlState())
    }
    
    public convenience init(title: String?, message: String?, isOkButtonLeft: Bool?, okButtonText: String?, cancelButtonText: String?, okButtonHandler: TouchHandler?, cancelButtonHandler: TouchHandler?) {
        self.init(title: title, message: message, alertType: AlertType.confirmation)
        if let okLeft = isOkButtonLeft {
            self.isOkButtonLeft = okLeft
        }
        self.message = message
        self.okTitle = okButtonText
        self.btnOk.setTitle(okTitle, for: UIControlState())
        self.cancelTitle = cancelButtonText
        self.btnCancel.setTitle(cancelTitle, for: UIControlState())
        self.okHandler = okButtonHandler
        self.btnOk.touchHandler = self.okHandler
        self.cancelHandler = cancelButtonHandler
        self.btnCancel.touchHandler = self.cancelHandler
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupWindow() {
        if viewNotReady() {
            return
        }
        let window = UIWindow(frame: (UIApplication.shared.keyWindow?.bounds)!)
        self.alertWindow = window
        self.alertWindow.windowLevel = UIWindowLevelAlert
        self.alertWindow.backgroundColor = UIColor.clear
        self.alertWindow.rootViewController = self
        self.previousWindow = UIApplication.shared.keyWindow
    }
    
    func setupViews() {
        if viewNotReady() {
            return
        }
        self.view = UIView(frame: (UIApplication.shared.keyWindow?.bounds)!)
        
        // Setup background view
        self.backgroundView = UIView(frame: self.view.bounds)
        
        // Gesture for background
        if allowTouchOutsideToDismiss == true {
            self.tapOutsideTouchGestureRecognizer.addTarget(self, action: #selector(EnhancedAlertView.dismissAlertView))
        }
        backgroundView.addGestureRecognizer(self.tapOutsideTouchGestureRecognizer)
        self.view.addSubview(backgroundView)
        
        // Setup alert view
        self.alertView                    = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.alertView.backgroundColor    = UIColor.white
        self.alertView.layer.cornerRadius = EnhancedAlertView.CornerRadius
        self.view.addSubview(alertView)
        
        // Setup title
        self.lbTitle               = UILabel()
        self.lbTitle.textAlignment = NSTextAlignment.center
        self.lbTitle.textColor     = EnhancedAlertView.titleColor
        self.lbTitle.font          = EnhancedAlertView.alertTitleFont ?? UIFont.boldSystemFont(ofSize: 16)
        self.alertView.addSubview(lbTitle)
        
        // Setup message
        self.lbMessage               = UILabel()
        self.lbMessage.textAlignment = NSTextAlignment.center
        self.lbMessage.numberOfLines = 0
        self.lbMessage.textColor     = EnhancedAlertView.messageColor
        self.lbMessage.font          = EnhancedAlertView.messageFont ?? UIFont.systemFont(ofSize: 14)
        self.alertView.addSubview(lbMessage)
        
        // Setup OK Button
        self.btnOk = ZButton(touchHandler: self.okHandler)
        if let okTitle = self.okTitle {
            self.btnOk.setTitle(okTitle, for: UIControlState())
        } else {
            self.btnOk.setTitle("OK", for: UIControlState())
        }
        self.btnOk.titleLabel?.font = EnhancedAlertView.buttonFont ?? UIFont.boldSystemFont(ofSize: 14)
        self.btnOk.titleColor = EnhancedAlertView.buttonTitleColor
        self.alertView.addSubview(btnOk)
        
        // Setup Cancel Button
        self.btnCancel = ZButton(touchHandler: self.cancelHandler)
        if let cancelTitle = self.cancelTitle {
            self.btnCancel.setTitle(cancelTitle, for: UIControlState())
        } else {
            self.btnCancel.setTitle("Cancel", for: UIControlState())
        }
        self.btnCancel.titleLabel?.font = EnhancedAlertView.buttonFont ?? UIFont.boldSystemFont(ofSize: 14)
        self.btnCancel.titleColor = EnhancedAlertView.buttonTitleColor
        self.alertView.addSubview(btnCancel)
        
        // Setup Close button
        self.btnClose = ZButton(touchHandler: self.closeHandler)
        if let closeTitle = self.closeTitle {
            self.btnClose.setTitle(closeTitle, for: UIControlState())
        } else {
            self.btnClose.setTitle("Close", for: UIControlState())
        }
        self.btnClose.titleLabel?.font = EnhancedAlertView.buttonFont ?? UIFont.boldSystemFont(ofSize: 14)
        self.btnClose.titleColor = EnhancedAlertView.buttonTitleColor
        self.alertView.addSubview(btnClose)
    }
    
    // MARK: - Life cycle
    
    open override func viewWillAppear(_ animated: Bool) {
        registerKeyboardEvents()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        unregisterKeyboardEvents()
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var hasContent = false
        
        if EnhancedAlertView.blurredBackground {
            self.backgroundView.subviews.forEach({ (view) in
                view.removeFromSuperview()
            })
            self.backgroundView.addSubview(UIImageView(image: UIImage.imageFromScreen().applyBlurWithRadius(2, tintColor: UIColor(white: 0.5, alpha: 0.7), saturationDeltaFactor: 1.8)))
        } else {
            self.backgroundView.backgroundColor = UIColor.black
            self.backgroundView.alpha = EnhancedAlertView.backgroundAlpha
        }
        
        if let title = self.alertTitle {
            hasContent      = true
            self.height     = EnhancedAlertView.padding
            lbTitle.text    = title
            let size        = lbTitle.sizeThatFits(CGSize(width: width - EnhancedAlertView.padding * 2, height: 600))
            let childHeight = size.height
            lbTitle.frame   = CGRect(x: EnhancedAlertView.padding, y: height, width: width - EnhancedAlertView.padding * 2, height: childHeight)
            height          += childHeight
        } else {
            self.height = 0
        }
        
        if let message = self.message {
            hasContent      = true
            self.height     += EnhancedAlertView.padding
            lbMessage.text  = message
            let size        = lbMessage.sizeThatFits(CGSize(width: width - EnhancedAlertView.padding * 2, height: 600))
            let childHeight = size.height
            lbMessage.frame = CGRect(x: EnhancedAlertView.padding, y: height, width: width - EnhancedAlertView.padding * 2, height: childHeight)
            height          += childHeight
        } else if let messageAttributedString = self.messageAttributedString {
            hasContent               = true
            self.height              += EnhancedAlertView.padding
            lbMessage.attributedText = messageAttributedString
            let size                 = lbMessage.sizeThatFits(CGSize(width: width - EnhancedAlertView.padding * 2, height: 600))
            let childHeight          = size.height
            lbMessage.frame          = CGRect(x: EnhancedAlertView.padding, y: height, width: width - EnhancedAlertView.padding * 2, height: childHeight)
            height                   += childHeight
        }
        
        if textFields.count > 0 {
            hasContent = true
            for textField in textFields {
                self.height += EnhancedAlertView.innerPadding
                textField.frame = CGRect(x: EnhancedAlertView.padding, y: height, width: width - EnhancedAlertView.padding * 2, height: EnhancedAlertView.textFieldHeight)
                self.height += EnhancedAlertView.textFieldHeight
            }
        }
        
        self.height += EnhancedAlertView.padding
        
        switch alertType {
        case .alert:
            if hasContent {
                self.height += EnhancedAlertView.buttonSectionExtraGap
            }
            let buttonWidth             = width -  EnhancedAlertView.padding * 2
            btnClose.frame              = CGRect(x: EnhancedAlertView.padding, y: height, width: buttonWidth, height: EnhancedAlertView.buttonHeight)
            btnClose.setBackgroundImage(UIImage.imageWithSolidColor(EnhancedAlertView.positiveColor, size: btnClose.frame.size), for: UIControlState())
            btnClose.layer.cornerRadius = EnhancedAlertView.cornerRadius
            btnClose.clipsToBounds      = true
            btnClose.addTarget(self, action: #selector(EnhancedAlertView.buttonDidTouch(_:)), for: UIControlEvents.touchUpInside)
            self.height                 += EnhancedAlertView.buttonHeight
            
        case .confirmation:
            if hasContent {
                self.height += EnhancedAlertView.buttonSectionExtraGap
            }
            let buttonWidth = (width - EnhancedAlertView.padding * 2 - EnhancedAlertView.innerPadding) / 2
            
            if isOkButtonLeft {
                btnOk.frame = CGRect(x: EnhancedAlertView.padding, y: height, width: buttonWidth, height: EnhancedAlertView.buttonHeight)
                btnCancel.frame = CGRect(x: EnhancedAlertView.padding + EnhancedAlertView.innerPadding + buttonWidth, y: height, width: buttonWidth, height: EnhancedAlertView.buttonHeight)
            } else {
                btnCancel.frame = CGRect(x: EnhancedAlertView.padding, y: height, width: buttonWidth, height: EnhancedAlertView.buttonHeight)
                btnOk.frame = CGRect(x: EnhancedAlertView.padding + EnhancedAlertView.innerPadding + buttonWidth, y: height, width: buttonWidth, height: EnhancedAlertView.buttonHeight)
            }
            
            btnCancel.setBackgroundImage(UIImage.imageWithSolidColor(EnhancedAlertView.negativeColor, size: btnCancel.frame.size), for: UIControlState())
            btnCancel.layer.cornerRadius = EnhancedAlertView.cornerRadius
            btnCancel.clipsToBounds = true
            self.btnCancel.addTarget(self, action: #selector(EnhancedAlertView.buttonDidTouch(_:)), for: UIControlEvents.touchUpInside)
            
            btnOk.setBackgroundImage(UIImage.imageWithSolidColor(EnhancedAlertView.positiveColor, size: btnOk.frame.size), for: UIControlState())
            btnOk.layer.cornerRadius = EnhancedAlertView.cornerRadius
            btnOk.clipsToBounds = true
            self.btnOk.addTarget(self, action: #selector(EnhancedAlertView.buttonDidTouch(_:)), for: UIControlEvents.touchUpInside)
            self.height += EnhancedAlertView.buttonHeight
            
        case .multipleChoice:
            if hasContent {
                self.height += EnhancedAlertView.buttonSectionExtraGap
            }
            for button in buttons {
                button.frame = CGRect(x: EnhancedAlertView.padding, y: height, width: width - EnhancedAlertView.padding * 2, height: EnhancedAlertView.buttonHeight)
                if button.color != nil {
                    button.setBackgroundImage(UIImage.imageWithSolidColor(button.color!, size: button.frame.size), for: UIControlState())
                } else {
                    button.setBackgroundImage(UIImage.imageWithSolidColor(EnhancedAlertView.neutralColor, size: button.frame.size), for: UIControlState())
                }
                if button.titleColor != nil {
                    button.setTitleColor(button.titleColor!, for: UIControlState())
                } else {
                    button.setTitleColor(EnhancedAlertView.buttonTitleColor, for: UIControlState())
                }
                button.layer.cornerRadius = EnhancedAlertView.cornerRadius
                button.clipsToBounds = true
                self.height += EnhancedAlertView.buttonHeight
                if button != buttons.last {
                    self.height += EnhancedAlertView.innerPadding
                }
            }
        }
        
        self.height += EnhancedAlertView.padding
        let bounds = UIScreen.main.bounds
        self.alertView.frame = CGRect(x: bounds.width/2 - width/2, y: bounds.height/2 - height/2, width: width, height: height)
    }
    
    // MARK: - Override methods
    
    open override var preferredStatusBarStyle : UIStatusBarStyle {
        if let statusBarStyle = EnhancedAlertView.statusBarStyle {
            return statusBarStyle
        }
        return UIApplication.shared.statusBarStyle
    }
    
    // MARK: - Convenient helpers
    
    open func addTextField(_ identifier: String, placeHolder: String) {
        addTextField(identifier,
                     placeHolder: placeHolder,
                     keyboardType: UIKeyboardType.default,
                     font: EnhancedAlertView.messageFont ?? UIFont.systemFont(ofSize: 14),
                     padding: EnhancedAlertView.padding,
                     isSecured: false)
    }
    
    open func addTextField(_ identifier: String, placeHolder: String, isSecured: Bool) {
        addTextField(identifier,
                     placeHolder: placeHolder,
                     keyboardType: UIKeyboardType.default,
                     font: EnhancedAlertView.messageFont ?? UIFont.systemFont(ofSize: 14),
                     padding: EnhancedAlertView.padding,
                     isSecured: true)
    }
    
    
    open func addTextField(_ identifier: String, placeHolder: String, keyboardType: UIKeyboardType) {
        addTextField(identifier,
                     placeHolder: placeHolder,
                     keyboardType: keyboardType,
                     font: EnhancedAlertView.messageFont ?? UIFont.systemFont(ofSize: 14),
                     padding: EnhancedAlertView.padding,
                     isSecured: false)
    }
    
    open func addTextField(_ identifier: String, placeHolder: String, keyboardType: UIKeyboardType, font: UIFont, padding: CGFloat, isSecured: Bool) {
        let textField                = ZTextField(identifier: identifier)
        textField.leftView           = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: EnhancedAlertView.textFieldHeight))
        textField.rightView          = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: EnhancedAlertView.textFieldHeight))
        textField.leftViewMode       = UITextFieldViewMode.always
        textField.rightViewMode      = UITextFieldViewMode.always
        textField.keyboardType       = keyboardType
        textField.font               = font
        textField.placeholder        = placeHolder
        textField.layer.cornerRadius = EnhancedAlertView.cornerRadius
        textField.layer.borderWidth  = 1
        
        if EnhancedAlertView.textFieldBorderColor != nil {
            textField.layer.borderColor = EnhancedAlertView.textFieldBorderColor!.cgColor
        } else if EnhancedAlertView.positiveColor != nil {
            textField.layer.borderColor = EnhancedAlertView.positiveColor!.cgColor
        }
        
        if EnhancedAlertView.textFieldBackgroundColor != nil {
            textField.backgroundColor = EnhancedAlertView.textFieldBackgroundColor
        }
        
        if EnhancedAlertView.textFieldTextColor != nil {
            textField.textColor = EnhancedAlertView.textFieldTextColor
        }
        
        textField.clipsToBounds = true
        if isSecured {
            textField.isSecureTextEntry = true
        }
        textFields.append(textField)
        self.alertView.addSubview(textField)
    }
    
    open func addButton(_ title: String, touchHandler: @escaping TouchHandler) {
        addButton(title, font: EnhancedAlertView.messageFont ?? UIFont.boldSystemFont(ofSize: 14), touchHandler: touchHandler)
    }
    
    open func addButton(_ title: String, color: UIColor?, titleColor: UIColor?, touchHandler: @escaping TouchHandler) {
        addButton(title, font: EnhancedAlertView.messageFont ?? UIFont.boldSystemFont(ofSize: 14), color: color, titleColor: titleColor, touchHandler: touchHandler)
    }
    
    open func addButton(_ title: String, hexColor: String, hexTitleColor: String, touchHandler: @escaping TouchHandler) {
        addButton(title, font: EnhancedAlertView.messageFont ?? UIFont.boldSystemFont(ofSize: 14), color: UIColor.color(hexColor), titleColor: UIColor.color(hexTitleColor), touchHandler: touchHandler)
    }
    
    open func addButton(_ title: String, font: UIFont, touchHandler: @escaping TouchHandler) {
        addButton(title, font: font, color: nil, titleColor: nil, touchHandler: touchHandler)
    }
    
    open func addButton(_ title: String, font: UIFont, color: UIColor?, titleColor: UIColor?, touchHandler: @escaping TouchHandler) {
        weak var weakSelf = self
        let button              = ZButton(touchHandler: touchHandler)
        button.setTitle(title, for: UIControlState())
        button.color            = color
        button.titleColor       = titleColor
        button.titleLabel?.font = font
        button.addTarget(weakSelf!, action: #selector(EnhancedAlertView.buttonDidTouch(_:)), for: UIControlEvents.touchUpInside)
        buttons.append(button)
        self.alertView.addSubview(button)
    }
    
    open func getTextFieldWithIdentifier(_ identifier: String) -> UITextField? {
        return textFields.filter({ textField in
            textField.identifier == identifier
        }).first
    }
    
    @objc func buttonDidTouch(_ sender: ZButton) {
        weak var weakSelf = self
        if let listener = sender.touchHandler {
            if (weakSelf != nil) {
                listener(weakSelf!)
            }
        }
    }
    
    // MARK: - Handle keyboard
    
    func registerKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(EnhancedAlertView.keyboardDidShow(_:)), name:NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(EnhancedAlertView.keyboardDidHide(_:)), name:NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.oldFrame = self.alertView.frame
            let extraHeight = (oldFrame.size.height + oldFrame.origin.y) - (self.view.frame.size.height - keyboardSize.height)
            if extraHeight > 0 {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.alertView.frame = CGRect(x: self.oldFrame.origin.x, y: self.oldFrame.origin.y - extraHeight - 8, width: self.oldFrame.size.width, height: self.oldFrame.size.height)
                })
            }
        }
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        if self.oldFrame == nil {
            return
        }
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.alertView.frame = self.oldFrame
        })
    }
    
    func unregisterKeyboardEvents() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Show & hide
    
    open func show() {
        if EnhancedAlertView.duration < 0.1
        {
            EnhancedAlertView.duration = 0.3
        }
        
        showWithDuration(Double(EnhancedAlertView.duration))
    }
    
    @objc open func dismissAlertView() {
        
        if EnhancedAlertView.duration < 0.1
        {
            EnhancedAlertView.duration = 0.3
        }
        
        dismissWithDuration(0.3)
    }
    
    open func showWithDuration(_ duration: Double) {
        if viewNotReady() {
            return
        }
        
        if EnhancedAlertView.damping <= 0
        {
            EnhancedAlertView.damping = 0.1
        }
        else if EnhancedAlertView.damping >= 1
        {
            EnhancedAlertView.damping = 1
        }
        
        if EnhancedAlertView.initialSpringVelocity <= 0
        {
            EnhancedAlertView.initialSpringVelocity = 0.1
        }
        else if EnhancedAlertView.initialSpringVelocity >= 1
        {
            EnhancedAlertView.initialSpringVelocity = 1
        }
        
        
        self.alertWindow.addSubview(self.view)
        self.alertWindow.makeKeyAndVisible()
        switch EnhancedAlertView.showAnimation {
        case .fadeIn:
            self.view.alpha = 0
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.view.alpha = 1
            })
        case .flyLeft:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRect(x: self.view.frame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = EnhancedAlertView.backgroundAlpha
            })
        case .flyRight:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRect(x: -currentFrame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = 1
            })
        case .flyBottom:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRect(x: currentFrame.origin.x, y: self.view.frame.size.height, width: currentFrame.size.width, height: currentFrame.size.height)
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = EnhancedAlertView.backgroundAlpha
            })
        case .flyTop:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRect(x: currentFrame.origin.x, y: -currentFrame.size.height, width: currentFrame.size.width, height: currentFrame.size.height)
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = EnhancedAlertView.backgroundAlpha
            })
        case .bounceTop:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRect(x: currentFrame.origin.x, y: -currentFrame.size.height*4, width: currentFrame.size.width, height: currentFrame.size.height)
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: EnhancedAlertView.damping, initialSpringVelocity: EnhancedAlertView.initialSpringVelocity, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = EnhancedAlertView.backgroundAlpha
                
            }, completion: {  _ in
                
            })
            
        case .bounceBottom:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRect(x: currentFrame.origin.x, y: self.view.frame.size.height, width: currentFrame.size.width, height: currentFrame.size.height)
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: EnhancedAlertView.damping, initialSpringVelocity: EnhancedAlertView.initialSpringVelocity, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = EnhancedAlertView.backgroundAlpha
                
            }, completion: {  _ in
                
            })
        case .bounceLeft:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRect(x: self.view.frame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: EnhancedAlertView.damping, initialSpringVelocity: EnhancedAlertView.initialSpringVelocity, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = EnhancedAlertView.backgroundAlpha
                
            }, completion: {  _ in
                
            })
            
        case .bounceRight:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRect(x: -currentFrame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: EnhancedAlertView.damping, initialSpringVelocity: EnhancedAlertView.initialSpringVelocity, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = EnhancedAlertView.backgroundAlpha
                
            }, completion: {  _ in
                
            })
        }
    }
    
    open func dismissWithDuration(_ duration: Double) {
        let completion = { (complete: Bool) -> Void in
            if complete {
                self.view.removeFromSuperview()
                self.alertWindow.isHidden = true
                self.alertWindow = nil
                self.previousWindow.makeKeyAndVisible()
                self.previousWindow = nil
            }
        }
        
        switch EnhancedAlertView.hideAnimation {
        case .fadeOut:
            self.view.alpha = 1
            UIView.animate(withDuration: duration,
                           animations: { () -> Void in
                            self.view.alpha = 0
            }, completion: completion)
        case .flyLeft:
            self.backgroundView.alpha = EnhancedAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration,
                           animations: { () -> Void in
                            self.alertView.frame = CGRect(x: self.view.frame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
                            self.backgroundView.alpha = 0
            },
                           completion: completion)
        case .flyRight:
            self.backgroundView.alpha = EnhancedAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration,
                           animations: { () -> Void in
                            self.alertView.frame = CGRect(x: -currentFrame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
                            self.backgroundView.alpha = 0
            },
                           completion: completion)
        case .flyBottom:
            self.backgroundView.alpha = EnhancedAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration,
                           animations: { () -> Void in
                            self.alertView.frame = CGRect(x: currentFrame.origin.x, y: self.view.frame.size.height, width: currentFrame.size.width, height: currentFrame.size.height)
                            self.backgroundView.alpha = 0
            },
                           completion: completion)
        case .flyTop:
            self.backgroundView.alpha = EnhancedAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration,
                           animations: { () -> Void in
                            self.alertView.frame = CGRect(x: currentFrame.origin.x, y: -currentFrame.size.height, width: currentFrame.size.width, height: currentFrame.size.height)
                            self.backgroundView.alpha = 0
            },
                           completion: completion)
            
        case .bounceBottom:
            self.backgroundView.alpha = EnhancedAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: EnhancedAlertView.damping, initialSpringVelocity: EnhancedAlertView.initialSpringVelocity, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                self.alertView.frame = CGRect(x: currentFrame.origin.x, y: self.view.frame.size.height, width: currentFrame.size.width, height: currentFrame.size.height)
                self.backgroundView.alpha = 0
            }, completion: completion)
            
        case .bounceTop:
            self.backgroundView.alpha = EnhancedAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: EnhancedAlertView.damping, initialSpringVelocity: EnhancedAlertView.initialSpringVelocity, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                self.alertView.frame = CGRect(x: currentFrame.origin.x, y: -currentFrame.size.height, width: currentFrame.size.width, height: currentFrame.size.height)
                self.backgroundView.alpha = 0
            }, completion: completion)
            
        case .bounceLeft:
            
            self.backgroundView.alpha = EnhancedAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: EnhancedAlertView.damping, initialSpringVelocity: EnhancedAlertView.initialSpringVelocity, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                self.alertView.frame = CGRect(x: self.view.frame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
                self.backgroundView.alpha = 0
            }, completion: completion)
            
        case .bounceRight:
            
            self.backgroundView.alpha = EnhancedAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: EnhancedAlertView.damping, initialSpringVelocity: EnhancedAlertView.initialSpringVelocity, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                self.alertView.frame = CGRect(x: -currentFrame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
                self.backgroundView.alpha = 0
            }, completion: completion)
        }
    }
    
    func viewNotReady() -> Bool {
        return UIApplication.shared.keyWindow == nil
    }
    
    open override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.view.layoutSubviews()
        self.view.setNeedsDisplay()
    }
    
    // MARK: - Subclasses
    
    class ZButton: UIButton {
        
        var touchHandler: TouchHandler?
        
        var color: UIColor?
        var titleColor: UIColor? {
            didSet {
                weak var weakSelf = self
                weakSelf?.setTitleColor(titleColor, for: UIControlState())
            }
        }
        
        init(touchHandler: TouchHandler?) {
            super.init(frame: CGRect.zero)
            self.touchHandler = touchHandler
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
    
    class ZTextField: UITextField {
        
        var identifier: String!
        
        init(identifier: String) {
            super.init(frame: CGRect.zero)
            self.identifier = identifier
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
    }
}
