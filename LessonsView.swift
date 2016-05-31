//
//  LessonsView.swift
//  teeline-app
//

import UIKit

class LessonsView: UIViewController {
    
    private var sectionId: Int?
    
    // Requires a section ID to display lesons for
    init(sectionId: Int) {
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Lessons"
        self.sectionId = sectionId
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
        
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints for multi-device compatibility
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .LeadingMargin, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .TrailingMargin, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Height, multiplier: 0.95, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))
        
        let loadingLabel = UILabel()
        
        loadingLabel.font = UIFont.italicSystemFontOfSize(17)
        loadingLabel.text = "Loading lessons..."
        loadingLabel.textColor = UIColor.pureBlack()
        loadingLabel.textAlignment = .Center
        
        parentStackView.addArrangedSubview(loadingLabel)
        
        // Send an API request to fetch lessons per section
        var request = TeelineAPI.Request()
        
        request.path = "/lessons/section/\(self.sectionId!)"
        request.type = .FETCH
        
        TeelineAPI.sendCachedRequest(request, secondaryHandler: {
            response in
            
            if (response.jsonError != 0) {
                loadingLabel.text = response.json["message"] as? String
            } else {
                loadingLabel.removeFromSuperview()
                
                let lessons: [[String: AnyObject]] = response.json["lessons"] as! [[String: AnyObject]]
                
                // Add each lesson to the view when found
                for lesson in lessons {
                    let lessonId = lesson["lesson_id"] as! Int
                    let name = lesson["name"] as! String
                    
                    let lessonButton = UIButton()
                    
                    lessonButton.setTitle(name, forState: .Normal)
                    lessonButton.titleLabel!.font = UIFont.systemBold()
                    lessonButton.titleLabel!.textColor = UIColor.pureWhite()
                    lessonButton.backgroundColor = UIColor.indexColor(self.sectionId! - 1)
                    lessonButton.tag = lessonId
                    lessonButton.layer.cornerRadius = 8
                    lessonButton.clipsToBounds = true
                    
                    parentStackView.addArrangedSubview(lessonButton)
                    
                    lessonButton.addTarget(self, action: #selector(LessonsView.lessonPressUp(_:)), forControlEvents: .TouchUpInside)
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
    
    @objc private func lessonPressUp(sender: UIButton) {
        self.navigationController!.pushViewController(LessonView(lessonId: sender.tag), animated: true)
    }
}
