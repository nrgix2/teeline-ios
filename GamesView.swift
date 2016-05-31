//
//  GamesView.swift
//  teeline-app
//

import UIKit

class GamesView: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Games"
        
        // Set the current tab bar item
        self.tabBarItem = UITabBarItem(
            title: self.title,
            image: UIImage(named: "Games-Gray"),
            selectedImage: UIImage(named: "Games")
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.pureWhite()
        
        self.edgesForExtendedLayout = .None
        
        // Parent stack view to hold child views
        let parentStackView = UIStackView()
        
        parentStackView.axis = .Vertical
        parentStackView.alignment = .Fill
        parentStackView.distribution = .FillEqually
        parentStackView.spacing = 4
        
        self.view.addSubview(parentStackView)
        
        // Prevents other constraints from being added automatically
        // Ensures only our custom constraints exist
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Multi-device constraints
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .LeadingMargin, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .TrailingMargin, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Height, multiplier: 0.95, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))
        
        let loadingLabel = UILabel()
        
        loadingLabel.font = UIFont.italicSystemFontOfSize(17)
        loadingLabel.text = "Loading games..."
        loadingLabel.textColor = UIColor.pureBlack()
        loadingLabel.textAlignment = .Center
        
        parentStackView.addArrangedSubview(loadingLabel)
        
        var request = TeelineAPI.Request()
        
        request.path = "/games"
        request.type = .FETCH
        
        // Send a cached request to fetch game names
        TeelineAPI.sendCachedRequest(request, secondaryHandler: {
            response in
            
            if (response.jsonError != 0) {
                loadingLabel.text = response.json["message"] as? String
            } else {
                loadingLabel.removeFromSuperview()
                
                let games: [[String: AnyObject]] = response.json["games"] as! [[String: AnyObject]]
                
                for game in games {
                    let gameStackView = UIStackView()
                    
                    gameStackView.axis = .Vertical
                    gameStackView.alignment = .Fill
                    gameStackView.distribution = .FillProportionally
                    gameStackView.spacing = 2
                    
                    parentStackView.addArrangedSubview(gameStackView)
                    
                    // Load id, name, desc, requiredLevel from the JSON
                    let id = game["game_id"] as! Int
                    let name = game["name"] as! String
                    let description = game["description"] as! String
                    let requiredLevel = game["required_level"] as! Int
                    
                    let gameButton = UIButton()
                    
                    gameButton.titleLabel!.font = UIFont.systemBold()
                    gameButton.titleLabel!.textColor = UIColor.pureWhite()
                    gameButton.tag = id
                    gameButton.layer.cornerRadius = 8
                    gameButton.clipsToBounds = true
                    
                    // If the account level is within the bounds, show it
                    // If not then show an unlock button for later
                    if (APIStore.getAccount()!.level >= requiredLevel) {
                        gameButton.setTitle("Play \(name)", forState: .Normal)
                        gameButton.backgroundColor = UIColor.indexColor(7 - id)
                    } else {
                        gameButton.setTitle("Unlock at Level \(requiredLevel)", forState: .Normal)
                        gameButton.backgroundColor = UIColor.grayColorE()
                        gameButton.enabled = false
                    }
                    
                    gameStackView.addArrangedSubview(gameButton)
                    
                    gameButton.addTarget(self, action: #selector(GamesView.gamePressUp(_:)), forControlEvents: .TouchUpInside)
                    
                    // Show a game subtitle under game button
                    let gameSubtitle = UILabel()
                    
                    gameSubtitle.font = UIFont.boldSystemFontOfSize(12)
                    gameSubtitle.text = description
                    gameSubtitle.textColor = UIColor.pureBlack()
                    gameSubtitle.textAlignment = .Center
                    
                    gameStackView.addArrangedSubview(gameSubtitle)
                }
            }
        })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    // Load the game based on ID
    @objc private func gamePressUp(sender: UIButton) {
        // Animate to the game view and show the game
        self.presentViewController(GamesView(), animated: true, completion: nil)
    }
}
