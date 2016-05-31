//
//  LessonView.swift
//  teeline-app
//

import UIKit

class LessonView: UIViewController {
    
    private var lessonId: Int?
    
    // Requires a lesson ID to display
    init(lessonId: Int) {
        super.init(nibName: nil, bundle: nil)
        
        self.title = ""
        self.lessonId = lessonId
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
        
        // Setup multi-device constraints
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .LeadingMargin, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .TrailingMargin, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Height, multiplier: 0.95, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: parentStackView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))
        
        let loadingLabel = UILabel()
        
        loadingLabel.font = UIFont.italicSystemFontOfSize(17)
        loadingLabel.text = "Loading lesson..."
        loadingLabel.textColor = UIColor.pureBlack()
        loadingLabel.textAlignment = .Center
        
        parentStackView.addArrangedSubview(loadingLabel)
        
        // Create a new request to load the lesson data
        var request = TeelineAPI.Request()
        
        request.path = "/lessons/\(self.lessonId!)"
        request.type = .FETCH
        
        // Send a cached request
        TeelineAPI.sendCachedRequest(request, secondaryHandler: {
            response in
            
            if (response.jsonError != 0) {
                loadingLabel.text = response.json["message"] as? String
            } else {
                loadingLabel.removeFromSuperview()
                
                let lesson: [String: AnyObject] = (response.json["lessons"] as! [[String: AnyObject]])[0]
                
                let name = lesson["name"] as! String
                let content = lesson["content"] as! String
                
                self.title = name
                
                // Show a context text box
                let contentTextView = UITextView()
                
                contentTextView.font = UIFont.system()
                contentTextView.textColor = UIColor.pureBlack()
                contentTextView.text = content
                // Ensure content text can not be edited
                contentTextView.editable = false
                
                parentStackView.addArrangedSubview(contentTextView)
            }
        })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
}
