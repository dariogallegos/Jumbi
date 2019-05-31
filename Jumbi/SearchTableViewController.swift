//
//  SearchTableViewController.swift
//  Jumbi
//
//  Created by Dev2 on 31/05/2019.
//  Copyright © 2019 dario. All rights reserved.
//

import UIKit

class SearchTableViewController: UIViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    
    var trushies = [Trush]()
    let searchController = UISearchController(searchResultsController: nil)
    
//    var countryList = ["Aceite usado de vehículos","Aceite usado de cocina","Aparatos electrónicos ","Auriculares","Baterías","Cascos","Disolventes","Escombros","Fluorescentes","Instrumentos de oficina", "Medicamentos","Mecheros", "Pilas", "Pinturas","Radiografías"]
    
    
    var searchedCountry = [Trush]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trushies = [
            Trush(category:"Chocolate", name:"Chocolate Bar"),
            Trush(category:"Chocolate", name:"Chocolate Chip"),
            Trush(category:"Chocolate", name:"Dark Chocolate"),
            Trush(category:"Hard", name:"Lollipop"),
            Trush(category:"Hard", name:"Candy Cane"),
            Trush(category:"Hard", name:"Jaw Breaker"),
            Trush(category:"Other", name:"Caramel"),
            Trush(category:"Other", name:"Sour Chew"),
            Trush(category:"Other", name:"Gummi Bear"),
            Trush(category:"Other", name:"Candy Floss"),
            Trush(category:"Chocolate", name:"Chocolate Coin"),
            Trush(category:"Chocolate", name:"Chocolate Egg"),
            Trush(category:"Other", name:"Jelly Beans"),
            Trush(category:"Other", name:"Liquorice"),
            Trush(category:"Hard", name:"Toffee Apple")]
    }
    
}

extension SearchTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
           return searchedCountry.count
        } else {
           return trushies.count
       }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
//        if searching {
//            cell?.textLabel?.text = searchedCountry[indexPath.row]
//        } else {
//            cell?.textLabel?.text = countryList[indexPath.row]
//        }
//        return cell!
        
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let trush: Trush
        if searching {
            trush = searchedCountry[indexPath.row]
        } else {
            trush = trushies[indexPath.row]
        }
        cell.textLabel!.text = trush.name
        cell.detailTextLabel!.text = trush.category
        return cell
    }
    
}


extension SearchTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // cuando pulsamos sobre la barra se abre el teclado
        self.view.endEditing(true)
        
//        searchedCountry = countryList.filter(
//            {$0.lowercased().prefix(searchText.count) == searchText.lowercased()}
//        )
        
        
        searchedCountry = trushies.filter({( trush : Trush) -> Bool in
            let doesCategoryMatch = (scope == "All") || (trush.category == scope)
            
            if searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && trush.name.lowercased().contains(searchText.lowercased())
            }
        })
        
        searching = true
        tblView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblView.reloadData()
        //cuando le damos a cancelar desaparece el teclado
        self.view.endEditing(false)
    }
}

