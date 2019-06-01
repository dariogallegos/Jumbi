//
//  SearchTableViewController.swift
//  Jumbi
//
//  Created by Dev2 on 31/05/2019.
//  Copyright © 2019 dario. All rights reserved.
//

import UIKit

class SearchTableViewController: UIViewController {

    //    var countryList = ["Aceite usado de vehículos","Aceite usado de cocina","Aparatos electrónicos ","Auriculares","Baterías","Cascos","Disolventes","Escombros","Fluorescentes","Instrumentos de oficina", "Medicamentos","Mecheros", "Pilas", "Pinturas","Radiografías"]
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    
    var trushies = [Trush]()
    var filteredTrush = [Trush]()
    let searchController = UISearchController(searchResultsController: nil)
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Setup the Search Controller
        //searchController.searchResultsUpdater = self
        //searchController.obscuresBackgroundDuringPresentation = false
        //searchController.searchBar.placeholder = "Search trushies"
        //navigationItem.searchController = searchController
        definesPresentationContext = true
        
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
            Trush(category:"Chocolate", name:"Coin"),
            Trush(category:"Chocolate", name:"Chocolate Egg"),
            Trush(category:"Other", name:"Jelly Beans"),
            Trush(category:"Other", name:"Liquorice"),
            Trush(category:"Hard", name:"Toffee Apple")]
        

    }
    
}

extension SearchTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
           return filteredTrush.count
        } else {
           return trushies.count
       }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let trush: Trush
        if searching {
            trush = filteredTrush[indexPath.row]
        } else {
            trush = trushies[indexPath.row]
        }
        cell.textLabel!.text = trush.name
        cell.detailTextLabel!.text = trush.category
        
        return cell
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tblView.indexPathForSelectedRow {
                let trush: Trush
                if searching {
                    trush = filteredTrush[indexPath.row]
                } else {
                    trush = trushies[indexPath.row]
                }
                
                if let controller = segue.destination as? DetailViewController {
                    controller.detailTrush = trush
                    controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                    debugPrint(trush)
                }
            }
        }
    }
    
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    
    
}
// MARK : filtrado por categoria y nombre.

extension SearchTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // cuando pulsamos sobre la barra se abre el teclado
        //self.view.endEditing(true)
        
        filteredTrush = trushies.filter(
            {   $0.category.lowercased().prefix(searchText.count) == searchText.lowercased() ||
                $0.name.lowercased().prefix(searchText.count) == searchText.lowercased()
            }
        )
        
        debugPrint(filteredTrush)
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
// MARK :  hay que hacer una factoria similar a Plate para buscar los trushies

extension SearchTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText =  searchController.searchBar.text {
            debugPrint("Han escrito \(searchText)")
            filteredTrush = [Trush(category: "\(searchText)",name: "producto buscado")]
        }
        tblView.reloadData()
    }
}

