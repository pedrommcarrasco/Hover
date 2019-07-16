import UIKit
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
    
    
    
    @IBOutlet weak var tableView: UITableView!
    let datasource = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."]
    
    private let configuration = HoverConfiguration(icon: .cocoa,
                                                   color: .gradient(top: .lightBlue, bottom: .darkBlue),
                                                   size: 60.0,
                                                   initialPosition: .bottomRight)
    
    private lazy var hoverView = HoverView(with: configuration,
                                           items: [HoverItem(title: "Item 1", image: .add, onTap: {}),
                                                   HoverItem(title: "Item 2", image: .add, onTap: {}),
                                                   HoverItem(title: "Item 3", image: .add, onTap: {}),
                                                   HoverItem(title: "Item 4", image: .add, onTap: {})])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
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

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = datasource[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
