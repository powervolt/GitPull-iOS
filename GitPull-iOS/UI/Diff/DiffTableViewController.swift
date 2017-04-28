//
//  DiffTableViewController.swift
//  GitPull-iOS
//
//  Created by Bipin on 4/26/17.
//  Copyright © 2017 Bipin. All rights reserved.
//

import UIKit

class DiffTableViewController: UITableViewController {
    
    let viewModel = DiffViewModelImpl()
    var pullRequest: PullRequest!
    var isPotrait = true
    
    private let loader = LoaderView.viewFromXIB()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        
        self.navigationItem.title = pullRequest.title
        
        self.loader.showSpinner(on: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.fetchData(url: pullRequest.diffUrl) { (error) in
            if (error == nil) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.loader.hideSpinner(from: self)
                }
            }
            else {
                self.showErrorAlert(message: error?.localizedDescription ?? "Error retriving diff file")
            }
        }
    }
    
    private func setupTableView() {
        self.tableView.register(UINib(nibName: "DiffCell", bundle: nil), forCellReuseIdentifier: DiffTableViewCell.reuseIdentifier)
        self.tableView.register(UINib(nibName: "DiffSplitCell", bundle: nil), forCellReuseIdentifier: DiffSplitTableViewCell.reuseIdentifier)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { [weak self] (_) in
            DispatchQueue.main.async {
                let _ = self?.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.diffArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let diff = self.viewModel.diffArray[indexPath.section]
        
        if self.viewModel.shouldHideFullDiff(index: indexPath.section) {
            if let largeDiffCell = tableView.dequeueReusableCell(withIdentifier: LargeDiffTableViewCell.reuseIdentifier, for: indexPath) as? LargeDiffTableViewCell {
                largeDiffCell.setup(diffType: diff.type)
                return largeDiffCell
            }
        }
        
        if !isPotrait {
            if let splitCell = tableView.dequeueReusableCell(withIdentifier: DiffSplitTableViewCell.reuseIdentifier, for: indexPath) as? DiffSplitTableViewCell {
                splitCell.setup(diff: diff)
                return splitCell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DiffTableViewCell.reuseIdentifier, for: indexPath)
        
        if let cell = cell as? DiffTableViewCell {
            cell.setup(diff: diff)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.diffReloadIndex.insert(indexPath.section)
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }
}

extension DiffTableViewController {
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        //self.tableView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if (UIDevice.current.orientation.isPortrait) {
            self.isPotrait = true
        } else {
            self.isPotrait = false
        }
        
        coordinator.animate(alongsideTransition: { (_) in
            self.tableView.reloadData()
        }, completion: nil)
    }
}
