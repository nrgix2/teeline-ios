//
//  EditView.swift
//  teeline-app
//

import UIKit

class EditView: UIViewController {
    
    private var statusLabel: UILabel!
    private var usernameField: UITextField!
    private var passwordField: UITextField!
    private var confirmField: UITextField!
    private var emailField: UITextField!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Edit Profile"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.pureWhite()
        
        self.edgesForExtendedLayout = .None
        
        // Parent stack views to hold child views
        let parentStackView = UIStackView()
        
        parentStackView.axis = .Vertical
        parentStackView.alignment = .Fill
        parentStackView.distribution = .FillEqually
        parentStackView.spacing = 20
        
        self.view.addSubview(parentStackView)
        
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .LeadingMargin, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .TrailingMargin, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Height, multiplier: 0.95, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))
        
        let statusLabel = UILabel()
        
        statusLabel.font = UIFont.italicSystemFontOfSize(17)
        statusLabel.text = "Update your details below"
        statusLabel.textColor = UIColor.pureBlack()
        statusLabel.textAlignment = .Center
        
        parentStackView.addArrangedSubview(statusLabel)
        
        self.statusLabel = statusLabel
        
        // Username field for input
        let usernameField = UITextField()
        
        usernameField.font = UIFont.systemItalic()
        usernameField.borderStyle = .RoundedRect
        usernameField.placeholder = APIStore.getAccount()!.username
        usernameField.clearButtonMode = .WhileEditing
        usernameField.clearsOnBeginEditing = false
        usernameField.autocorrectionType = .No
        usernameField.autocapitalizationType = .None
        usernameField.keyboardType = .Alphabet
        usernameField.keyboardAppearance = .Dark
        
        parentStackView.addArrangedSubview(usernameField)
        
        usernameField.addTarget(self, action: #selector(EditView.hideKeyboard(_:)), forControlEvents: .EditingDidEndOnExit)
        usernameField.addTarget(self, action: #selector(EditView.usernameValidate(_:)), forControlEvents: .EditingChanged)
        
        self.usernameField = usernameField
        
        // Create a change username button
        let usernameButton = UIButton()
        
        usernameButton.setTitle("CHANGE USERNAME", forState: .Normal)
        usernameButton.titleLabel!.font = UIFont.boldSystemFontOfSize(17)
        usernameButton.titleLabel!.textColor = UIColor.pureWhite()
        usernameButton.backgroundColor = UIColor.redColorE()
        
        parentStackView.addArrangedSubview(usernameButton)
        
        usernameButton.addTarget(self, action: #selector(EditView.usernamePressUp(_:)), forControlEvents: .TouchUpInside)
        
        // Password field for input
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
        
        parentStackView.addArrangedSubview(passwordField)
        
        passwordField.addTarget(self, action: #selector(EditView.hideKeyboard(_:)), forControlEvents: .EditingDidEndOnExit)
        passwordField.addTarget(self, action: #selector(EditView.passwordValidate(_:)), forControlEvents: .EditingChanged)
        
        self.passwordField = passwordField
        
        // Confirm password field for input
        let confirmField = UITextField()
        
        confirmField.font = UIFont.systemItalic()
        confirmField.borderStyle = .RoundedRect
        confirmField.placeholder = "Password Again"
        confirmField.clearButtonMode = .Never
        confirmField.clearsOnBeginEditing = true
        confirmField.autocorrectionType = .No
        confirmField.autocapitalizationType = .None
        confirmField.keyboardType = .Alphabet
        confirmField.keyboardAppearance = .Dark
        confirmField.secureTextEntry = true
        
        parentStackView.addArrangedSubview(confirmField)
        
        confirmField.addTarget(self, action: #selector(EditView.hideKeyboard(_:)), forControlEvents: .EditingDidEndOnExit)
        confirmField.addTarget(self, action: #selector(EditView.passwordValidate(_:)), forControlEvents: .EditingChanged)
        
        self.confirmField = confirmField
        
        // Change password button, target to send request
        let passwordButton = UIButton()
        
        passwordButton.setTitle("CHANGE PASSWORD", forState: .Normal)
        passwordButton.titleLabel!.font = UIFont.boldSystemFontOfSize(17)
        passwordButton.titleLabel!.textColor = UIColor.pureWhite()
        passwordButton.backgroundColor = UIColor.greenColorE()
        
        parentStackView.addArrangedSubview(passwordButton)
        
        passwordButton.addTarget(self, action: #selector(EditView.passwordPressUp(_:)), forControlEvents: .TouchUpInside)
        
        // Email field for updated email
        let emailField = UITextField()
        
        emailField.font = UIFont.systemItalic()
        emailField.borderStyle = .RoundedRect
        emailField.placeholder = APIStore.getAccount()!.email
        emailField.clearButtonMode = .WhileEditing
        emailField.clearsOnBeginEditing = false
        emailField.autocorrectionType = .No
        emailField.autocapitalizationType = .None
        emailField.keyboardType = .EmailAddress
        emailField.keyboardAppearance = .Dark
        
        parentStackView.addArrangedSubview(emailField)
        
        emailField.addTarget(self, action: #selector(EditView.hideKeyboard(_:)), forControlEvents: .EditingDidEndOnExit)
        emailField.addTarget(self, action: #selector(EditView.emailValidate(_:)), forControlEvents: .EditingChanged)
        
        self.emailField = emailField
        
        // Email button target to send change email request
        let emailButton = UIButton()
        
        emailButton.setTitle("CHANGE EMAIL", forState: .Normal)
        emailButton.titleLabel!.font = UIFont.boldSystemFontOfSize(17)
        emailButton.titleLabel!.textColor = UIColor.pureWhite()
        emailButton.backgroundColor = UIColor.blueColorE()
        
        parentStackView.addArrangedSubview(emailButton)
        
        emailButton.addTarget(self, action: #selector(EditView.emailPressUp(_:)), forControlEvents: .TouchUpInside)
        
        // Global tap register to prevent stuck keyboards
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(EditView.hideKeyboard(_:))))
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    // Hide all keyboards when called, sender is ignored
    @objc private func hideKeyboard(sender: UIView) {
        self.usernameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        self.emailField.resignFirstResponder()
    }
    
    // Validate methods start
    @objc private func usernameValidate(sender: UITextField) {
        sender.text = Validation.sanitizeUsername(sender.text!)
    }
    
    @objc private func passwordValidate(sender: UITextField) {
        sender.text = Validation.sanitizePassword(sender.text!)
    }
    
    @objc private func emailValidate(sender: UITextField) {
        sender.text = Validation.sanitizeEmail(sender.text!)
    }
    // Validate methods end
    
    // Send username update request
    @objc private func usernamePressUp(sender: UIButton) {
        // Set status label whilst sending request
        self.statusLabel.font = UIFont.systemFontOfSize(17)
        self.statusLabel.text = "Connecting to server..."
        
        let usernameValidation = Validation.validateUsername(self.usernameField.text!)
        
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
        
        // Request username update
        var request = TeelineAPI.Request()
        
        request.path = "/update/username/\(self.usernameField.text!)"
        request.type = .UPDATE
        
        TeelineAPI.sendRequest(request, handler: {
            response in
            
            // Ensure status 205 (updated username)
            if (response.jsonError != 205) {
                self.statusLabel.text = response.json["message"] as? String
            } else {
                // Destroy session/account from memory
                APIStore.setAccount(nil)
                APIStore.setSession(nil)
                
                // Show username updated message on login view
                self.presentViewController(LoginView(statusMessage: "Your username was updated"), animated: true, completion: nil)
            }
        })
    }
    
    @objc private func passwordPressUp(sender: UIButton) {
        self.statusLabel.font = UIFont.systemFontOfSize(17)
        self.statusLabel.text = "Connecting to server..."
        
        let passwordValidation = Validation.validatePassword(self.passwordField.text!)
        
        // If password validation failed, show message why
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
        
        // Ensure that password field is the same as confirmation
        // No need to validate as implied by previous validation
        if (self.passwordField.text! != self.confirmField.text!) {
            self.statusLabel.text = "Passwords do not match"
            
            return
        }
        
        // Send request to the server
        var request = TeelineAPI.Request()
        
        request.path = "/update/password/\(self.passwordField.text!.secureHash())"
        request.type = .UPDATE
        
        TeelineAPI.sendRequest(request, handler: {
            response in
            
            // Ensure response status is 206 (updated password)
            if (response.jsonError != 206) {
                self.statusLabel.text = response.json["message"] as? String
            } else {
                // Destroy the session from memory
                APIStore.setAccount(nil)
                APIStore.setSession(nil)
                
                // Return to login view with new status message
                self.presentViewController(LoginView(statusMessage: "Your password was updated"), animated: true, completion: nil)
            }
        })
    }
    
    @objc private func emailPressUp(sender: UIButton) {
        self.statusLabel.font = UIFont.systemFontOfSize(17)
        self.statusLabel.text = "Connecting to server..."
        
        // Validate email before sending request
        let emailValidation = Validation.validateEmail(self.emailField.text!)
        
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
        
        // Send API request to the backend
        var request = TeelineAPI.Request()
        
        request.path = "/update/email/\(self.emailField.text!)"
        request.type = .UPDATE
        
        TeelineAPI.sendRequest(request, handler: {
            response in
            
            // Ensure request response is 207 (email updated)
            if (response.jsonError != 207) {
                self.statusLabel.text = response.json["message"] as? String
            } else {
                // Destroy account and session from memory
                APIStore.setAccount(nil)
                APIStore.setSession(nil)
                
                // Return to login to ensure fresh session details
                self.presentViewController(LoginView(statusMessage: "Your email was updated"), animated: true, completion: nil)
            }
        })
    }
}
