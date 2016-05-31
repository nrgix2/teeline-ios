//
//  StatisticsView.swift
//  teeline-app
//

import UIKit

class StatisticsView: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var leaderboardTable: UITableView?
    private var leaderboardData: [String]?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Statistics"
        
        // Set the current tab bar item
        self.tabBarItem = UITabBarItem(
            title: self.title,
            image: UIImage(named: "Statistics-Gray"),
            selectedImage: UIImage(named: "Statistics")
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.pureWhite()
        
        self.edgesForExtendedLayout = .None
        
        // Parent stack view to hold child view data
        let parentStackView = UIStackView()
        
        parentStackView.axis = .Vertical
        parentStackView.alignment = .Fill
        parentStackView.distribution = .Fill
        parentStackView.spacing = 5
        
        self.view.addSubview(parentStackView)
        
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints for device compat
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .LeadingMargin, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .TrailingMargin, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Height, multiplier: 0.95, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))
        
        let typePicker = UIPickerView()
        
        typePicker.delegate = self
        typePicker.dataSource = self
        
        parentStackView.addArrangedSubview(typePicker)
        
        typePicker.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraint(NSLayoutConstraint(item: typePicker, attribute: .Height, relatedBy: .Equal, toItem: parentStackView, attribute: .Height, multiplier: 0.15, constant: 0))
        
        // Add a leaderboard table
        let leaderboardTable = UITableView()
        
        leaderboardTable.separatorInset = UIEdgeInsetsZero
        leaderboardTable.contentInset = UIEdgeInsetsMake(0, -15, 0, 0)
        leaderboardTable.delegate = self
        leaderboardTable.dataSource = self
        leaderboardTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        parentStackView.addArrangedSubview(leaderboardTable)
        
        self.leaderboardTable = leaderboardTable
        
        self.leaderboardData = [String]()
        
        // Fetch leaderboard from backend API
        var request = TeelineAPI.Request()
        
        request.path = "/accounts/leaderboard"
        request.type = .FETCH
        
        TeelineAPI.sendRequest(request, handler: {
            response in
            
            if (response.jsonError != 0) {
                // TODO: Let the user know that there was an error
            } else {
                let accounts: [[String: AnyObject]] = response.json["leaderboard"] as! [[String: AnyObject]]
                
                // For each account response for the leaderboard
                // Show data followed by level and points
                for account in accounts {
                    let username = account["username"] as! String
                    let level = account["level"] as! Int
                    let points = account["points"] as! Int
                    
                    self.leaderboardData!.append("\(username.capitalizedString) - Level \(level) (\(points)/100)")
                }
            }
            
            self.leaderboardTable!.reloadData()
        })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    // Prevent table from being edited
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    // Number of rows is dynamic based on leaderboard data
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.leaderboardData!.count
    }
    
    // Set cell data for a specific index
    // I.e. 0 -> Data 0 of array
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.separatorInset = UIEdgeInsetsZero
        cell.textLabel!.font = UIFont.system()
        cell.textLabel!.textColor = UIColor.blackColorE()
        // Set data to the capitalized version of the row
        cell.textLabel!.text = self.leaderboardData![indexPath.row].capitalizedString
        
        return cell
    }
    
    // Set the number of components/columns (just one)
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Set the number fo rows to return within picker view
    // Rows are currently highest level, most goals, most sections and highest game scores
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    // Set the picker index and corresp. string
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch (row) {
        case 0:
            return "Highest Level"
        case 1:
            return "Most Goals Completed"
        case 2:
            return "Most Sections Completed"
        case 3:
            return "Highest Game Scores"
        default:
            return "Unknown"
        }
    }
}
