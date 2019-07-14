import UIKit
import Hover

class ViewController: UIViewController {
    
    private let hoverView = HoverView(color: .gradient(top: UIColor(red:0.00, green:0.70, blue:1.00, alpha:1.0), bottom: UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)),
                                      image: UIImage(named: "cocoa"),
                                      buttonSize: 60,
                                      items: [HoverItem(title: "Example", image: UIImage(named: "Add")!, onTap: {})])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(hoverView)
        hoverView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                hoverView.topAnchor.constraint(equalTo: view.topAnchor),
                hoverView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                hoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                hoverView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ]
        )
        
    }
}
