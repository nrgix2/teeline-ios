//
//  GoalsView.swift
//  teeline-app
//

import UIKit

class GoalsView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var goalTable: UITableView?
    private var recentGoals: [String]?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Goals"
        
        // Set the current tab bar item
        self.tabBarItem = UITabBarItem(
            title: self.title,
            image: UIImage(named: "Goals-Gray"),
            selectedImage: UIImage(named: "Goals")
        )
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
        parentStackView.spacing = 15
        
        self.view.addSubview(parentStackView)
        
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .LeadingMargin, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .TrailingMargin, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Height, multiplier: 0.95, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))
        
        // Show a label with the number of points a user has
        let pointsLabel = UILabel()
        
        pointsLabel.font = UIFont.systemItalic()
        pointsLabel.textColor = UIColor.grayColorE()
        pointsLabel.textAlignment = .Center
        // Load data from current account object within memory
        pointsLabel.text = "\(APIStore.getAccount()!.points)/100 Points"
        
        parentStackView.addArrangedSubview(pointsLabel)
        
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraint(NSLayoutConstraint(item: pointsLabel, attribute: .Height, relatedBy: .Equal, toItem: parentStackView, attribute: .Height, multiplier: 0.05, constant: 0))
        
        let progressView = UIProgressView()
        
        progressView.progress = Float(APIStore.getAccount()!.points) / 100.0
        progressView.progressTintColor = UIColor.blackColorE()

        parentStackView.addArrangedSubview(progressView)
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraint(NSLayoutConstraint(item: progressView, attribute: .Height, relatedBy: .Equal, toItem: parentStackView, attribute: .Height, multiplier: 0.1, constant: 0))
        
        // Create a stack view to hold all goals and table
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
        goalsLabel.text = "All Goals"
        
        detailStackView.addArrangedSubview(goalsLabel)
        
        // Create a goal table
        let goalTable = UITableView()
        
        goalTable.separatorInset = UIEdgeInsetsZero
        goalTable.contentInset = UIEdgeInsetsMake(0, -15, 0, 0)
        goalTable.delegate = self
        goalTable.dataSource = self
        goalTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        detailStackView.addArrangedSubview(goalTable)
        
        self.goalTable = goalTable
        
        self.recentGoals = [String]()
        
        var request = TeelineAPI.Request()
        
        request.path = "/goals"
        request.type = .FETCH
        
        // Send API request to load all goals
        TeelineAPI.sendRequest(request, handler: {
            response in
            
            if (response.jsonError != 0) {
                // TODO: Let the user know that there was an error
            } else {
                let goals: [[String: AnyObject]] = response.json["goals"] as! [[String: AnyObject]]
                
                for goal in goals {
                    let _ = goal["goal_id"] as! Int
                    let name = goal["name"] as! String
                    
                    self.recentGoals!.append(name.capitalizedString)
                }
            }
            
            self.goalTable!.reloadData()
        })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    // Prevent any editing of table cells
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    // Set the current row count to the number of recent goals
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recentGoals!.count
    }
    
    // Dynamically pull data for each row in table
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.separatorInset = UIEdgeInsetsZero
        cell.textLabel!.font = UIFont.system()
        cell.textLabel!.textColor = UIColor.blackColorE()
        // Set name to current recent goal returned by API
        cell.textLabel!.text = self.recentGoals![indexPath.row]
        
        return cell
    }
}
