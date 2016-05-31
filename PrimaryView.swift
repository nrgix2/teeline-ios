//
//  PrimaryView.swift
//  teeline-app
//

import UIKit

class PrimaryView: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.pureWhite()
        
        // Setup tab bar views to show
        // These views are wrapped within navigation controllers
        self.viewControllers = [
            self.wrapWithinNavigation(ProfileView()),
            self.wrapWithinNavigation(LearnView()),
            self.wrapWithinNavigation(GamesView()),
            self.wrapWithinNavigation(GoalsView()),
            self.wrapWithinNavigation(StatisticsView())
        ]
        
        self.tabBar.barStyle = .Black
        self.tabBar.tintColor = UIColor.pureWhite()
    }
    
    func wrapWithinNavigation(viewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController()
        
        // Set up the currently displayed navigation view
        navigationController.setViewControllers([viewController], animated: false)
        
        // Set the current tab bar item to the view controller's child item
        navigationController.tabBarItem = viewController.tabBarItem
        navigationController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.pureWhite()], forState: .Selected)
        
        // Set the navigation bar color to black and text color to white
        navigationController.navigationBar.barStyle = .Black
        navigationController.navigationBar.tintColor = UIColor.pureWhite()
        
        // Return wrapped navigation view
        return navigationController
    }
}
