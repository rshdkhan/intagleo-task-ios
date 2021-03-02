//
//  ViewController.swift
//  Task
//
//  Created by Rashid Khan on 3/1/21.
//

import UIKit

//
// MARK: Model View Presenter
//

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var photoesList: [UIModel] = []
    var allDataList: [UIModel] = []
    
    var presenter: HomeViewPresenter!
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellNibName)
        tableView.register(UINib(nibName: Constants.headerNibName, bundle: nil), forHeaderFooterViewReuseIdentifier: Constants.headerNibName)
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: Constants.searchImageName), style: .plain, target: self, action: #selector(searchButtonTap(_ :)))
        let filterButton = UIBarButtonItem(image: UIImage(systemName: Constants.filterImageName), style: .plain, target: self, action: #selector(filterButtonTap(_ :)))
        
        navigationItem.rightBarButtonItems = [searchButton, filterButton]
        
        self.presenter = HomeViewPresenter(homeView: self)
        self.presenter.getPhotoes()
        
        // init search controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.keyboardType = .asciiCapable
        self.searchController.searchBar.delegate = self
    }
    
    @objc func searchButtonTap(_ sender: UIBarButtonItem) {
        present(searchController, animated: true, completion: nil)
    }
    
    @objc func filterButtonTap(_ sender: UIBarButtonItem) {
        let actionsheet = UIAlertController(title: "Sort Order", message: "", preferredStyle: .actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: Constants.textAscending, style: .default, handler: { (action) in
            let sorted = self.photoesList.sorted(by: { $0.albumId! < $1.albumId! })
            self.photoesList = sorted

            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }))
        
        actionsheet.addAction(UIAlertAction(title: Constants.textDescending, style: .default, handler: { (action) in
            let sorted = self.photoesList.sorted(by: { $0.albumId! > $1.albumId! })
            self.photoesList = sorted

            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }))
        
        actionsheet.addAction(UIAlertAction(title: Constants.textCancel, style: .cancel, handler: nil))
        
        self.present(actionsheet, animated: true, completion: nil)
    }
}

// MARK: - Home View
extension HomeViewController: IHomeView {
    func displayPhotoes(photoes: [UIModel]) {
        self.photoesList = photoes
        self.allDataList = photoes
        
        self.tableView.reloadData()
    }
    
    func showLoader() {
        // show loader here
    }
    
    func hidLoader() {
        // hide loader here
    }
    
    func showErrorMessage(errorMessage: String) {
        // show error message
    }
}

// MARK: - Search Controller Delegates
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.photoesList = allDataList
            self.tableView.reloadData()
            return
        }
        
        var filteredList: [Item] = []
        if let searchTermInt = Int(searchText) {
            self.allDataList.forEach { (viewModel) in
                viewModel.items?.forEach({ (item) in
                    if let itemId = item.id, itemId == searchTermInt {
                        filteredList.append(item)
                    }
                })
            }
            
            self.photoesList = [UIModel(albumId: 0, items: filteredList)]
            self.tableView.reloadData()
        }
    }
}

// MARK: - Table View Delegates and Datasource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.photoesList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photoesList[section].items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellNibName, for: indexPath) as! HomeTableViewCell
        
        if let items = self.photoesList[indexPath.section].items {
            cell.setup(item: items[indexPath.row])
        }
        
        cell.selectionStyle = .none
        
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerNibName) as! HomeTableViewHeader

        let albumID = self.photoesList[section].albumId ?? -1
        header.lblSectionTitle.text = "Album ID: \(albumID)"

        return searchController.isActive ? nil : header
    }
}

