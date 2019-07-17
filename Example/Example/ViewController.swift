import UIKit
import WebKit
import Hover

extension UIImage {
    static var cocoa: UIImage {
        return UIImage(named: "cocoa")!
    }
    
    static var add: UIImage {
        return UIImage(named: "Add")!
    }
}

extension UIColor {
    
    static var lightBlue: UIColor {
        return UIColor(red:0.00, green:0.70, blue:1.00, alpha:1.0)
    }
    
    static var darkBlue: UIColor {
        return UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
    }
}



class ViewController: UIViewController {
    
    @IBOutlet weak var webview: WKWebView!
    
    private let configuration = HoverConfiguration(icon: .cocoa, color: .gradient(top: .lightBlue, bottom: .darkBlue))
    
    private lazy var hoverView = HoverView(with: configuration,
                                           items: [HoverItem(title: "Item 1", image: .add, onTap: {}),
                                                   HoverItem(title: "Item 2", image: .add, onTap: {}),
                                                   HoverItem(title: "Item 3", image: .add, onTap: {}),
                                                   HoverItem(title: "Item 4", image: .add, onTap: {})])
    
    
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
                hoverView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ]
        )
        
    }
}
