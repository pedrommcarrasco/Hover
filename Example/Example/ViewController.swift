import UIKit
import Hover

class ViewController: UIViewController {
    
    private let hoverView = HoverView(buttonSize: 100, anchors: .all)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(hoverView)
        hoverView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                hoverView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                hoverView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                hoverView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                hoverView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            ]
        )
        
    }
}
