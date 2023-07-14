//
//  ViewController.swift
//  TestUIApp
//
//  Created by Ryan Helgeson on 7/8/23.
//

import UIKit
import RyanUI

class ViewController: UIViewController {
    let model = HomeViewModel()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: HomeActionItemTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HomeActionItemTableViewCell.identifier)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! HomeActionItemTableViewCell
        
        if let item = cell.item {
            switch item.action {
            case .spinnerButton:
                let vc = SpinnerButtonViewController()
                present(vc, animated: true)
                break
            case .creditCardScanner:
                let vc = CreditCardScanner(delegate: model)
                present(vc, animated: true)
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeActionItemTableViewCell.identifier, for: indexPath) as! HomeActionItemTableViewCell
        cell.item = model.actions[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.actions.count
    }
}


