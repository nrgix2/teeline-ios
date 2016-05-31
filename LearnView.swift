//
//  LearnView.swift
//  teeline-app
//

import UIKit

class LearnView: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Learn"
        
        // Set the current tab bar item
        self.tabBarItem = UITabBarItem(
            title: self.title,
            image: UIImage(named: "Learn-Gray"),
            selectedImage: UIImage(named: "Learn")
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.pureWhite()
        
        self.edgesForExtendedLayout = .None
        
        // Setup and refresh view
        self.refreshView()
    }
    
    override func viewWillAppear(animated: Bool) {
        if (APIStore.shouldReload) {
            // If the user data has been updated, refresh view
            self.refreshView()
            
            // Do not refresh until next user update
            APIStore.shouldReload = false
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    // External view to refresh the current view
    func refreshView() {
        self.clearView()
        
        // Parent stack view to hold child views
        let parentStackView = UIStackView()
        
        parentStackView.axis = .Vertical
        parentStackView.alignment = .Fill
        parentStackView.distribution = .FillEqually
        parentStackView.spacing = 4
        
        self.view.addSubview(parentStackView)
        
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Multi-device compat. constraints
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .LeadingMargin, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .TrailingMargin, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Height, multiplier: 0.95, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))
        
        // Show temporary section loading label
        let loadingLabel = UILabel()
        
        loadingLabel.font = UIFont.italicSystemFontOfSize(17)
        loadingLabel.text = "Loading sections..."
        loadingLabel.textColor = UIColor.pureBlack()
        loadingLabel.textAlignment = .Center
        
        parentStackView.addArrangedSubview(loadingLabel)
        
        var request = TeelineAPI.Request()
        
        request.path = "/sections"
        request.type = .FETCH
        
        // Send a cached request to fetch section data
        TeelineAPI.sendCachedRequest(request, secondaryHandler: {
            response in
            
            if (response.jsonError != 0) {
                loadingLabel.text = response.json["message"] as? String
            } else {
                for view in parentStackView.subviews {
                    view.removeFromSuperview()
                }
                
                let sections: [[String: AnyObject]] = response.json["sections"] as! [[String: AnyObject]]
                
                for section in sections {
                    let sectionStackView = UIStackView()
                    
                    sectionStackView.axis = .Vertical
                    sectionStackView.alignment = .Fill
                    sectionStackView.distribution = .FillProportionally
                    sectionStackView.spacing = 2
                    
                    parentStackView.addArrangedSubview(sectionStackView)
                    
                    // Fetch each part from the JSON response
                    let id = section["section_id"] as! Int
                    let name = section["name"] as! String
                    let description = section["description"] as! String
                    let requiredLevel = section["required_level"] as! Int
                    
                    let sectionButton = UIButton()
                    
                    sectionButton.titleLabel!.font = UIFont.systemBold()
                    sectionButton.titleLabel!.textColor = UIColor.pureWhite()
                    sectionButton.tag = id
                    sectionButton.layer.cornerRadius = 8
                    sectionButton.clipsToBounds = true
                    
                    if (APIStore.getAccount()!.level >= requiredLevel) {
                        sectionButton.setTitle(name, forState: .Normal)
                        sectionButton.backgroundColor = UIColor.indexColor(id - 1)
                    } else {
                        sectionButton.setTitle("Unlock at Level \(requiredLevel)", forState: .Normal)
                        sectionButton.backgroundColor = UIColor.grayColorE()
                        sectionButton.enabled = false
                    }
                    
                    sectionStackView.addArrangedSubview(sectionButton)
                    
                    // On button press, invoke sectionPressUp function
                    sectionButton.addTarget(self, action: #selector(LearnView.sectionPressUp(_:)), forControlEvents: .TouchUpInside)
                    
                    let sectionSubtitle = UILabel()
                    
                    sectionSubtitle.font = UIFont.boldSystemFontOfSize(12)
                    sectionSubtitle.text = description
                    sectionSubtitle.textColor = UIColor.pureBlack()
                    sectionSubtitle.textAlignment = .Center
                    
                    sectionStackView.addArrangedSubview(sectionSubtitle)
                }
            }
        })
    }
    
    func clearView() {
        // Remove all views from the current view
        // Used to refresh the view on level update
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
    }
    
    // Invoked when a section button is pressed
    @objc private func sectionPressUp(sender: UIButton) {
        // Show the lessons within a specific section for an ID
        self.navigationController!.pushViewController(LessonsView(sectionId: sender.tag), animated: true)
    }
}
