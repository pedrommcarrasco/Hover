import UIKit
import WebKit
import Hover
import os

class ViewController: UIViewController {
    
    @IBOutlet weak var webview: WKWebView!
    private let hoverView = HoverView(with: HoverConfiguration(image: .add, backgroundColor: .gradient(top: .pink, bottom: .darkPink), itemsTextColor: .darkPink),
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
