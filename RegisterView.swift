//
//  RegisterView.swift
//  teeline-app
//

import UIKit

class RegisterView: UIViewController {
    
    private var statusLabel: UILabel!
    private var usernameField: UITextField!
    private var passwordField: UITextField!
    private var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColorE()
        
        // Background image for aesthetics only
        let logoImageView = UIImageView(image: UIImage(named: "LogoLarge"))
        
        logoImageView.contentMode = .ScaleAspectFit
        logoImageView.alpha = 0.4
        logoImageView.tintColor = UIColor.pureWhite()
        logoImageView.frame.origin = CGPoint(x: -200, y: -200)
        
        self.view.addSubview(logoImageView)
        
        // Parent stack view to hold all objects
        let parentStackView = UIStackView()
        
        parentStackView.axis = .Vertical
        parentStackView.alignment = .Fill
        parentStackView.distribution = .FillProportionally
        parentStackView.spacing = 20
        
        self.view.addSubview(parentStackView)
        
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraint for multi-device compatibility
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .LeadingMargin, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .TrailingMargin, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Height, multiplier: 0.6, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))
        
        // Create stack views to hold input and buttons
        let inputStackView = UIStackView()
        
        inputStackView.axis = .Vertical
        inputStackView.alignment = .Fill
        inputStackView.distribution = .FillEqually
        inputStackView.spacing = 10
        
        parentStackView.addArrangedSubview(inputStackView)
        
        let buttonStackView = UIStackView()
        
        buttonStackView.axis = .Horizontal
        buttonStackView.alignment = .Fill
        buttonStackView.distribution = .FillProportionally
        buttonStackView.spacing = 0
        
        parentStackView.addArrangedSubview(buttonStackView)
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add constraint for button view to be at max 20% height
        self.view.addConstraint(NSLayoutConstraint(item: buttonStackView, attribute: .Height, relatedBy: .Equal, toItem: parentStackView, attribute: .Height, multiplier: 0.2, constant: 0))
        
        let statusLabel = UILabel()
        
        statusLabel.font = UIFont.italicSystemFontOfSize(17)
        statusLabel.text = "Create an account below"
        statusLabel.textColor = UIColor.pureWhite()
        statusLabel.textAlignment = .Center
        
        inputStackView.addArrangedSubview(statusLabel)
        
        self.statusLabel = statusLabel
        
        // Add a username field and register the validate events
        let usernameField = UITextField()
        
        usernameField.font = UIFont.systemItalic()
        usernameField.borderStyle = .RoundedRect
        usernameField.placeholder = "Username"
        usernameField.clearButtonMode = .WhileEditing
        usernameField.clearsOnBeginEditing = false
        usernameField.autocorrectionType = .No
        usernameField.autocapitalizationType = .None
        usernameField.keyboardType = .Alphabet
        usernameField.keyboardAppearance = .Dark
        
        inputStackView.addArrangedSubview(usernameField)
        
        // Registers validation and hide keyboard events
        usernameField.addTarget(self, action: #selector(RegisterView.hideKeyboard(_:)), forControlEvents: .EditingDidEndOnExit)
        usernameField.addTarget(self, action: #selector(RegisterView.usernameValidate(_:)), forControlEvents: .EditingChanged)
        
        self.usernameField = usernameField
        
        // Add password field to view
        let passwordField = UITextField()
        
        passwordField.font = UIFont.systemItalic()
        passwordField.borderStyle = .RoundedRect
        passwordField.placeholder = "Password"
        passwordField.clearButtonMode = .Never
        passwordField.clearsOnBeginEditing = true
        passwordField.autocorrectionType = .No
        passwordField.autocapitalizationType = .None
        passwordField.keyboardType = .Alphabet
        passwordField.keyboardAppearance = .Dark
        passwordField.secureTextEntry = true
        
        inputStackView.addArrangedSubview(passwordField)
        
        // Register hide keyboard and password validation events
        passwordField.addTarget(self, action: #selector(RegisterView.hideKeyboard(_:)), forControlEvents: .EditingDidEndOnExit)
        passwordField.addTarget(self, action: #selector(RegisterView.passwordValidate(_:)), forControlEvents: .EditingChanged)
        
        self.passwordField = passwordField
        
        // Add email field and register events
        let emailField = UITextField()
        
        emailField.font = UIFont.systemItalic()
        emailField.borderStyle = .RoundedRect
        emailField.placeholder = "Email"
        emailField.clearButtonMode = .WhileEditing
        emailField.clearsOnBeginEditing = false
        emailField.autocorrectionType = .No
        emailField.autocapitalizationType = .None
        emailField.keyboardType = .EmailAddress
        emailField.keyboardAppearance = .Dark
        
        inputStackView.addArrangedSubview(emailField)
        
        // Register hide keyboard and validation events
        emailField.addTarget(self, action: #selector(RegisterView.hideKeyboard(_:)), forControlEvents: .EditingDidEndOnExit)
        emailField.addTarget(self, action: #selector(RegisterView.emailValidate(_:)), forControlEvents: .EditingChanged)
        
        self.emailField = emailField
        
        let finishButton = UIButton()
        
        finishButton.setTitle("COMPLETE", forState: .Normal)
        finishButton.titleLabel!.font = UIFont.systemBold()
        finishButton.titleLabel!.textColor = UIColor.pureWhite()
        finishButton.backgroundColor = UIColor.greenColorE()
        
        buttonStackView.addArrangedSubview(finishButton)
        
        finishButton.addTarget(self, action: #selector(RegisterView.finishPressDown(_:)), forControlEvents: .TouchDown)
        finishButton.addTarget(self, action: #selector(RegisterView.finishPressUp(_:)), forControlEvents: .TouchUpInside)
        
        let cancelButton = UIButton()
        
        cancelButton.setTitle("CANCEL", forState: .Normal)
        cancelButton.titleLabel!.font = UIFont.systemBold()
        cancelButton.titleLabel!.textColor = UIColor.pureWhite()
        cancelButton.backgroundColor = UIColor.redColorE()
        
        buttonStackView.addArrangedSubview(cancelButton)
        
        // Register back button to return to login screen
        cancelButton.addTarget(self, action: #selector(RegisterView.backPressDown(_:)), forControlEvents: .TouchDown)
        cancelButton.addTarget(self, action: #selector(RegisterView.backPressUp(_:)), forControlEvents: .TouchUpInside)
        
        // Global gesture to ensure that user can escape keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterView.hideKeyboard(_:))))
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @objc private func hideKeyboard(sender: UIView) {
        self.usernameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        self.emailField.resignFirstResponder()
    }
    
    // Validation methods start (sanitize only)
    @objc private func usernameValidate(sender: UITextField) {
        sender.text = Validation.sanitizeUsername(sender.text!)
    }
    
    @objc private func passwordValidate(sender: UITextField) {
        sender.text = Validation.sanitizePassword(sender.text!)
    }
    
    @objc private func emailValidate(sender: UITextField) {
        sender.text = Validation.sanitizeEmail(sender.text!)
    }
    // Validation methods end
    
    @objc private func finishPressDown(sender: UIButton) {
        // Animate finish button
        let originalColor = sender.backgroundColor
        
        sender.backgroundColor = UIColor.darkGreenColorE()
        
        UIView.animateWithDuration(
            1,
            animations: {
                sender.backgroundColor = originalColor
            }
        )
    }
    
    @objc private func finishPressUp(sender: UIButton) {
        // Sends a registration request to the server
        self.statusLabel.font = UIFont.systemFontOfSize(17)
        self.statusLabel.text = "Connecting to server..."
        
        let usernameValidation = Validation.validateUsername(self.usernameField.text!)
        
        // Validate username and show error
        if let reasonValue = usernameValidation {
            switch (reasonValue) {
            case Validation.FailureReason.TOO_LONG:
                self.statusLabel.text = "Your username is too long"
            case Validation.FailureReason.TOO_SHORT:
                self.statusLabel.text = "Your username is too short"
            case Validation.FailureReason.NO_MATCH:
                self.statusLabel.text = "Invalid characters in username"
            default:
                self.statusLabel.text = "Your username is invalid"
            }
            
            return
        }
        
        let passwordValidation = Validation.validatePassword(self.passwordField.text!)
        
        // Validate password and show error
        if let reasonValue = passwordValidation {
            switch (reasonValue) {
            case Validation.FailureReason.TOO_SHORT:
                self.statusLabel.text = "Your password is too short"
            case Validation.FailureReason.NO_MATCH:
                self.statusLabel.text = "Invalid characters in password"
            default:
                self.statusLabel.text = "Your password is invalid"
            }
            
            return
        }
        
        let emailValidation = Validation.validateEmail(self.emailField.text!)
        
        // Validate email and show error
        if let reasonValue = emailValidation {
            switch (reasonValue) {
            case Validation.FailureReason.TOO_LONG:
                self.statusLabel.text = "Your email is too long"
            case Validation.FailureReason.TOO_SHORT:
                self.statusLabel.text = "Your email is too short"
            case Validation.FailureReason.NO_DOMAIN:
                self.statusLabel.text = "Your email needs a domain"
            case Validation.FailureReason.NO_MATCH:
                self.statusLabel.text = "Invalid email address format"
            default:
                self.statusLabel.text = "Your email is invalid"
            }
            
            return
        }
        
        var request = TeelineAPI.Request()
        
        request.path = "/accounts/\(self.usernameField.text!)/\(self.passwordField.text!.secureHash())/\(self.emailField.text!)"
        request.type = .CREATE
        
        // Send registration request
        TeelineAPI.sendRequest(request, handler: {
            response in
            
            // If request was not a status 202, show error message
            // Error message is returned from request
            if (response.jsonError != 202) {
                self.statusLabel.text = response.json["message"] as? String
            } else {
                self.presentViewController(LoginView(statusMessage: response.json["message"] as? String), animated: true, completion: nil)
            }
        })
    }
    
    @objc private func backPressDown(sender: UIButton) {
        let originalColor = sender.backgroundColor
        
        sender.backgroundColor = UIColor.darkRedColorE()
        
        UIView.animateWithDuration(
            1,
            animations: {
                sender.backgroundColor = originalColor
            }
        )
    }
    
    @objc private func backPressUp(sender: UIButton) {
        // Return to login screen with no status message shown
        self.presentViewController(LoginView(statusMessage: nil), animated: true, completion: nil)
    }
}
