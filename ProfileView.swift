//
//  ProfileView.swift
//  teeline-app
//

import UIKit

class ProfileView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var usernameLabel: UILabel?
    private var goalTable: UITableView?
    private var recentGoals: [String]?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Profile"

        self.tabBarItem = UITabBarItem(
            title: self.title,
            image: UIImage(named: "Profile-Gray"),
            selectedImage: UIImage(named: "Profile")
        )
        
        // Set the current tab bar item
        let editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: nil)
        
        editButton.tintColor = UIColor.pureWhite()
        editButton.target = self
        editButton.action = #selector(ProfileView.editPressUp(_:))
        
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.pureWhite()
        
        self.edgesForExtendedLayout = .None
        
        // Create a parent stack view for child objects
        let parentStackView = UIStackView()
        
        parentStackView.axis = .Vertical
        parentStackView.alignment = .Fill
        parentStackView.distribution = .Fill
        parentStackView.spacing = 20
        
        // Parent stack view to hold child views
        self.view.addSubview(parentStackView)
        
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Multi-device compatibility
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .LeadingMargin, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .TrailingMargin, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Height, multiplier: 0.95, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))
        
        let usernameLabel = UILabel()
        
        usernameLabel.font = UIFont.systemBold()
        usernameLabel.textColor = UIColor.blackColorE()
        usernameLabel.textAlignment = .Center
        usernameLabel.text = "\(APIStore.getAccount()!.username.capitalizedString) - Level \(APIStore.getAccount()!.level)"
        
        parentStackView.addArrangedSubview(usernameLabel)
        
        self.usernameLabel = usernameLabel
        
        // Add an avatar image, or default to NoAvatar image (red bg image)
        let avatarImage = UIImageView(image: UIImage(named: "NoAvatar"))
        
        avatarImage.contentMode = .ScaleAspectFill
        avatarImage.layer.cornerRadius = 16
        avatarImage.clipsToBounds = true
        
        parentStackView.addArrangedSubview(avatarImage)
        
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraint(NSLayoutConstraint(item: avatarImage, attribute: .Height, relatedBy: .Equal, toItem: parentStackView, attribute: .Height, multiplier: 0.4, constant: 0))
        
        // Fetch Gravatar image data async
        GravatarAPI.avatarImage("\(APIStore.getAccount()!.email)", size: 256, handler: {
            image in
            
            // Set avatar image to new image returned by API
            avatarImage.image = image
        })
        
        let detailStackView = UIStackView()
        
        detailStackView.axis = .Vertical
        detailStackView.alignment = .Fill
        detailStackView.distribution = .Fill
        detailStackView.spacing = 5
        
        parentStackView.addArrangedSubview(detailStackView)
        
        let goalsLabel = UILabel()
        
        goalsLabel.font = UIFont.systemItalic()
        goalsLabel.textColor = UIColor.grayColorE()
        goalsLabel.textAlignment = .Center
        goalsLabel.text = "Recent Goals"
        
        detailStackView.addArrangedSubview(goalsLabel)
        
        let goalTable = UITableView()
        
        goalTable.separatorInset = UIEdgeInsetsZero
        goalTable.contentInset = UIEdgeInsetsMake(0, -15, 0, 0)
        goalTable.delegate = self
        goalTable.dataSource = self
        goalTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        detailStackView.addArrangedSubview(goalTable)
        
        self.goalTable = goalTable
        
        self.recentGoals = [String]()
        
        // Create API request to load recent goals
        var request = TeelineAPI.Request()
        
        request.path = "/goals/recent"
        request.type = .FETCH
        
        TeelineAPI.sendRequest(request, handler: {
            response in
            
            if (response.jsonError != 0) {
                // TODO: Let the user know that there was an error
            } else {
                let goals: [[String: AnyObject]] = response.json["goals"] as! [[String: AnyObject]]
                
                // For each goal, show the name on the recent goals table
                for goal in goals {
                    let _ = goal["goal_id"] as! Int
                    let name = goal["name"] as! String
                    
                    self.recentGoals!.append(name.capitalizedString)
                }
            }
            
            self.goalTable!.reloadData()
        })
    }
    
    // Reload when the account details have changed
    override func viewWillAppear(animated: Bool) {
        if (APIStore.shouldReload) {
            // Show updated username and level
            usernameLabel!.text = "\(APIStore.getAccount()!.username.capitalizedString) - Level \(APIStore.getAccount()!.level)"
            
            // Prevent infinite reload
            APIStore.shouldReload = false
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    // When edit button pressed, show edit view on navigation controller
    func editPressUp(sender: AnyObject) {
        self.navigationController!.pushViewController(EditView(), animated: true)
    }
    
    // Allow editing of path
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // Called when a cell is changed
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            // TODO: Delete cell and send API request
        }
    }
    
    // Fetch number of rows from a section from response
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recentGoals!.count
    }
    
    // Set the contents of a specific cell at an index
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.separatorInset = UIEdgeInsetsZero
        cell.textLabel!.font = UIFont.system()
        cell.textLabel!.textColor = UIColor.blackColorE()
        // Dynamically fetch recent goals from data
        cell.textLabel!.text = self.recentGoals![indexPath.row]
        
        return cell
    }
}
