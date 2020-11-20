//
//  CalendarVC.swift
//  WeatherLy
//
//  Created by Muslim on 20.11.2020.
//  Copyright © 2020 Emil Ismayilov. All rights reserved.
//

import UIKit

protocol CalendarDelegate: class {
    func userDidSelectItem(with item: List)
}

class CalendarVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: CalendarDelegate?
    var data = [List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
 
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}


extension CalendarVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CalendarCell.self), for: indexPath) as! CalendarCell
        cell.setupCellWith(item: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.userDidSelectItem(with: data[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}
