//
//  HomeVC.swift
//  FoodJournalApp
//
//  Created by Hakan Adanur on 2.02.2023.
//

import UIKit
import UIScrollView_InfiniteScroll

class HomeVC: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var viewModel: HomeVM!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeCell = UINib(nibName: "HomeCell", bundle: nil)
        tableView.register(homeCell, forCellReuseIdentifier: "homeCell")
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.viewDidLoad()
        setupUI()
    }

    @objc private func addButtonTapped(){
        let createFoodVC = CreateFoodVC.create()
        navigationController?.pushViewController(createFoodVC, animated: true)
     }
    
    private func setupUI() {
        title = "Food Journal"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        tableView.infiniteScrollDirection = .vertical
        tableView.addInfiniteScroll { tableView in
            self.viewModel.viewDidLoad()
            self.tableView.reloadData()
            self.tableView.finishInfiniteScroll()
        }
    }
}

extension HomeVC {
    static func create() -> HomeVC {
        let vc = HomeVC(nibName: "HomeVC", bundle: nil)
        vc.viewModel = HomeVM()
        return vc
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeCell
        let data = viewModel.foods[indexPath.row]
        cell.configure(food: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteData(from: viewModel.foods, at: indexPath.row)
        }
    }
}

extension HomeVC: HomeVMDelegate {
    func bringDataOnSuccess() {
        tableView.reloadData()
    }
    
    func bringDataOnError() {
        showAlert(title: "Error", message: "Error")
    }
    
    func deleteDataOnSuccess(at index: Int) {
        viewModel.foods.remove(at: index)
        tableView.reloadData()
    }
    
    func deleteDataOnError() {
        showAlert(title: "Error", message: "Error")
    }
    
    
}
