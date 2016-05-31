//
//  LoginView.swift
//  teeline-app
//

import UIKit
import AVFoundation

class LoginView: UIViewController {

    private var statusMessage: String?
    private var videoPlayer: AVPlayer?
    private var statusLabel: UILabel!
    private var usernameField: UITextField!
    private var passwordField: UITextField!
    
    init(statusMessage: String?) {
        super.init(nibName: nil, bundle: nil)
        
        // Set the status message, only filled when redirected
        // e.g. registration went through therefore let the user know
        self.statusMessage = statusMessage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColorE()
        
        // Load the video from the app exectuable
        let videoUrl = NSBundle.mainBundle().URLForResource("video_background", withExtension: "mp4")
        
        // If video was loaded, use video as a background player
        if let videoUrlValue = videoUrl {
            let videoPlayer = AVPlayer(URL: videoUrlValue)
            
            // Ensure video is muted forever
            videoPlayer.muted = true
            videoPlayer.actionAtItemEnd = .None
            
            // Create a new background video layer for the player
            let videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
            
            // Set the frame for the layer to be the entire view
            videoPlayerLayer.frame = self.view.frame
            // Set the video scaling option to ensure it always fills the screen
            videoPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPlayerLayer.opacity = 0.7
            videoPlayerLayer.player!.muted = true
            
            do {
                // Solution to prevent video from stopping other music
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            } catch {
                //
            }
            
            // Add an event handler on video finish to restart the video and play in reverse
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginView.videoPlayerFinished(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.videoPlayer?.currentItem)
            
            // Add the created video layer to the view
            self.view.layer.addSublayer(videoPlayerLayer)
            
            self.videoPlayer = videoPlayer
        }
        
        // Parent stack view to hold other views within
        let parentStackView = UIStackView()
        
        parentStackView.axis = .Vertical
        parentStackView.alignment = .Fill
        parentStackView.distribution = .Fill
        parentStackView.spacing = 20
        
        self.view.addSubview(parentStackView)
        
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraint the view to allow multi-device compatibility
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .LeadingMargin, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .TrailingMargin, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Height, multiplier: 0.9, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))
        
        // Load the logo from the assets bundle
        let logoImageView = UIImageView(image: UIImage(named: "Logo"))
        
        // Ensure logo fits within the view and none is cut
        logoImageView.contentMode = .ScaleAspectFit
        
        parentStackView.addArrangedSubview(logoImageView)
        
        let inputStackView = UIStackView()
        
        inputStackView.axis = .Vertical
        inputStackView.alignment = .Fill
        inputStackView.distribution = .FillEqually
        inputStackView.spacing = 10
        
        parentStackView.addArrangedSubview(inputStackView)
        
        inputStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Keep logo at 30% of the entire view height at most
        self.view.addConstraint(NSLayoutConstraint(item: inputStackView, attribute: .Height, relatedBy: .Equal, toItem: parentStackView, attribute: .Height, multiplier: 0.3, constant: 0))
        
        // Create a button stack view within the parent stack view
        let buttonStackView = UIStackView()
        
        buttonStackView.axis = .Vertical
        buttonStackView.alignment = .Fill
        buttonStackView.distribution = .FillEqually
        buttonStackView.spacing = 0
        
        parentStackView.addArrangedSubview(buttonStackView)
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Keep button stack view at 25% height at max
        self.view.addConstraint(NSLayoutConstraint(item: buttonStackView, attribute: .Height, relatedBy: .Equal, toItem: parentStackView, attribute: .Height, multiplier: 0.25, constant: 0))
        
        // Create a status label at the top of the view
        let statusLabel = UILabel()
        
        statusLabel.font = UIFont.italicSystemFontOfSize(17)
        statusLabel.textColor = UIColor.pureWhite()
        statusLabel.textAlignment = .Center
        statusLabel.text = "Please enter your details"
        
        inputStackView.addArrangedSubview(statusLabel)
        
        self.statusLabel = statusLabel
        
        // Create a username input field
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
        
        usernameField.addTarget(self, action: #selector(LoginView.hideKeyboard(_:)), forControlEvents: .EditingDidEndOnExit)
        usernameField.addTarget(self, action: #selector(LoginView.usernameValidate(_:)), forControlEvents: .EditingChanged)
        
        self.usernameField = usernameField
        
        // Create a password input field
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
        
        passwordField.addTarget(self, action: #selector(LoginView.hideKeyboard(_:)), forControlEvents: .EditingDidEndOnExit)
        passwordField.addTarget(self, action: #selector(LoginView.passwordValidate(_:)), forControlEvents: .EditingChanged)
        
        self.passwordField = passwordField
        
        // Create a login button within the button stack
        let loginButton = UIButton()
        
        loginButton.setTitle("LOGIN", forState: .Normal)
        loginButton.titleLabel!.font = UIFont.systemBold()
        loginButton.titleLabel!.textColor = UIColor.pureWhite()
        loginButton.backgroundColor = UIColor.yellowColorE()
        
        buttonStackView.addArrangedSubview(loginButton)
        
        loginButton.addTarget(self, action: #selector(LoginView.loginPressDown(_:)), forControlEvents: .TouchDown)
        loginButton.addTarget(self, action: #selector(LoginView.loginPressUp(_:)), forControlEvents: .TouchUpInside)
        
        // Create a register button within the button stack
        let registerButton = UIButton()
        
        registerButton.setTitle("REGISTER", forState: .Normal)
        registerButton.titleLabel!.font = UIFont.systemBold()
        registerButton.titleLabel!.textColor = UIColor.pureWhite()
        registerButton.backgroundColor = UIColor.orangeColorE()
        
        buttonStackView.addArrangedSubview(registerButton)
        
        registerButton.addTarget(self, action: #selector(LoginView.registerPressDown(_:)), forControlEvents: .TouchDown)
        registerButton.addTarget(self, action: #selector(LoginView.registerPressUp(_:)), forControlEvents: .TouchUpInside)
        
        // Add a general gesture for when a user taps outside a text box
        // This gesture will call the hide keyboard function on tap
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginView.hideKeyboard(_:))))
        
        // If the status message was set in the constructor, display it
        // If no status message was set (i.e. came from splash) then ignore it
        if (self.statusMessage != nil) {
            self.statusLabel.font = UIFont.systemFontOfSize(17)
            self.statusLabel.text = self.statusMessage
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        // If the video player was created, play the video when this view appears
        if let videoPlayerValue = self.videoPlayer {
            videoPlayerValue.play()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @objc private func videoPlayerFinished(notification: NSNotification) {
        // Invoked once video player has finished playing video
        // Will return the playtime back to the start
        if let playerItemValue = notification.object as? AVPlayerItem {
            playerItemValue.seekToTime(kCMTimeZero)
        }
    }
    
    @objc private func hideKeyboard(sender: UIView) {
        // Cloes all field textboxes currently open
        self.usernameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
    }
    
    @objc private func usernameValidate(sender: UITextField) {
        // Automatically validates as the user types
        sender.text = Validation.sanitizeUsername(sender.text!)
    }
    
    @objc private func passwordValidate(sender: UITextField) {
        // Similarly, validates password as the user types
        sender.text = Validation.sanitizePassword(sender.text!)
    }
    
    @objc private func loginPressDown(sender: UIButton) {
        // When the login button is pressed, play a small animation
        let originalColor = sender.backgroundColor
        
        sender.backgroundColor = UIColor.darkYellowColorE()
        
        UIView.animateWithDuration(
            1,
            animations: {
                sender.backgroundColor = originalColor
            }
        )
    }
    
    @objc private func loginPressUp(sender: UIButton) {
        // When the login button press is confirmed, start the request
        self.statusLabel.font = UIFont.systemFontOfSize(17)
        self.statusLabel.text = "Connecting to server..."
        
        // Validate username against static functions
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
        
        // Validate password against static functions
        let passwordValidation = Validation.validatePassword(self.passwordField.text!)
        
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
        
        // Create a new request once username / password are validated
        var request = TeelineAPI.Request()
        
        request.path = "/sessions/\(self.usernameField.text!)/\(self.passwordField.text!.secureHash())"
        request.type = .CREATE
        
        // Send request async and wait for a reply
        TeelineAPI.sendRequest(request, handler: {
            response in
            
            if (response.jsonError != 201) {
                self.statusLabel.text = response.json["message"] as? String
            } else {
                let sessionHash = response.json["session_hash"] as! String
                
                let sessionValidation = Validation.validateSession(sessionHash)
                
                if let reasonValue = sessionValidation {
                    switch (reasonValue) {
                    case Validation.FailureReason.TOO_LONG:
                        self.statusLabel.text = "Your session was too long"
                    case Validation.FailureReason.TOO_SHORT:
                        self.statusLabel.text = "Your session was too short"
                    case Validation.FailureReason.NO_MATCH:
                        self.statusLabel.text = "Your session was incorrect"
                    default:
                        self.statusLabel.text = "Unknown session error"
                    }
                    
                    return
                }
                
                // Set the global session to be the one returned by backend
                APIStore.setSession(APIStore.Session(sessionHash: sessionHash))
                
                self.statusLabel.text = "Loading your profile..."
                
                var request = TeelineAPI.Request()
                
                request.path = "/accounts"
                request.type = .FETCH
                
                // Send another request to load the current account information
                // Account information is only available after first request
                TeelineAPI.sendRequest(request, handler: {
                    response in
                    
                    if (response.jsonError != 0) {
                        self.statusLabel.text = response.json["message"] as? String
                    } else {
                        var account = APIStore.Account()
                        
                        account.accountId = response.json["account_id"] as! Int
                        account.username = response.json["username"] as! String
                        account.email = response.json["email"] as! String
                        account.level = response.json["level"] as! Int
                        account.points = response.json["points"] as! Int
                        
                        APIStore.setAccount(account)
                        
                        self.presentViewController(PrimaryView(), animated: true, completion: nil)
                    }
                })
            }
        })
    }
    
    @objc private func registerPressDown(sender: UIButton) {
        // Animate register button on press down
        let originalColor = sender.backgroundColor
        
        sender.backgroundColor = UIColor.darkOrangeColorE()
        
        UIView.animateWithDuration(
            1,
            animations: {
                sender.backgroundColor = originalColor
            }
        )
    }
    
    @objc private func registerPressUp(sender: UIButton) {
        // Send an animated view change to redirect to registration view
        self.presentViewController(RegisterView(), animated: true, completion: nil)
    }
}
