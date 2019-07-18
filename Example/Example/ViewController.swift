import UIKit
import WebKit
import Hover
import os

extension UIImage {
    
    static var add: UIImage {
        return UIImage(named: "add")!
    }
    
    static var anywhere: UIImage {
        return UIImage(named: "anywhere")!
    }
    
    static var star: UIImage {
        return UIImage(named: "star")!
    }
    
    static var gesture: UIImage {
        return UIImage(named: "gesture")!
    }
    
    
}

extension UIColor {
    
    static var pink: UIColor {
        return UIColor(red: 1.00, green: 0.18, blue: 0.33, alpha: 1.0)
    }
    
    static var darkPink: UIColor {
        return UIColor(red: 0.32, green: 0.03, blue: 0.08, alpha: 1.0)
    }
}



class ViewController: UIViewController {
    
    @IBOutlet weak var webview: WKWebView!
    private let hoverView = HoverView(with: HoverConfiguration(icon: .add, color: .gradient(top: .pink, bottom: .darkPink)),
                                      items: [HoverItem(title: "Drop it Anywhere", image: .anywhere) { os_log("Tapped 'Drop it anywhere'") },
                                              HoverItem(title: "Gesture Driven", image: .gesture) { os_log("Tapped 'Gesture driven'") },
                                              HoverItem(title: "Give it a Star", image: .star) { os_log("Tapped 'Give it a star'") }])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: "https://github.com/pedrommcarrasco") else { return }
        
        webview.load(URLRequest(url: url))
        
        view.addSubview(hoverView)
        hoverView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                hoverView.topAnchor.constraint(equalTo: view.topAnchor),
                hoverView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                hoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                hoverView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
        )
    }
}
