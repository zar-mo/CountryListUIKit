//
//  ViewController.swift
//  CountryListUIKit
//
//  Created by Abouzar Moradian on 10/2/24.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    @IBOutlet weak var serachBarView: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var viewModel: HomeViewModel!
    var countries = [CountryModel]()
    var filteredCountries = [CountryModel]()
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubscriptions()
        tableView.dataSource = self
        serachBarView.delegate = self
     
    }
    
    func initSubscriptions(){
        viewModel.dataPublisher
            .sink { completiton in
                switch completiton{
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error.localizedDescription)
                }
               
            } receiveValue: { [weak self] data in
                
                DispatchQueue.main.async{
                    self?.countries = data
                    self?.filteredCountries = data
                    self?.tableView.reloadData()
                }
            }
            .store(in: &cancellables)

    }


}

extension  HomeViewController:  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as? CountryCellView else { return UITableViewCell()}
        cell.country = filteredCountries[indexPath.row]
        return cell
    }
    
}

extension HomeViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        if searchText.isEmpty {
                    filteredCountries = countries
                } else {
                    filteredCountries = countries.filter({ country in
                        country.name.lowercased().hasPrefix(searchText.lowercased())

                    })
                }
        
        tableView.reloadData()
    }
    
   
}
    
