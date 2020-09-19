//
//  MapSearchViewController.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/14/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import UIKit
import MapKit


protocol LocationInputViewDelegate {
    func executeSearch(query: String)
}


class MapSearchViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var fromText: UITextField!
    @IBOutlet weak var toText: UITextField!
    @IBOutlet weak var locationTableView: UITableView!
    
    private let mapView = MKMapView()
    private var searchResults = [MKPlacemark]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        
        toText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    

    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let query = textField.text else { return }
        executeSearch(query: query)
        locationTableView.reloadData()
    }
    
    

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         return "Search places"
     }
    

      public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return searchResults.count
     }

     
      public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! MapSearchTableViewCell
        
        
        if  indexPath.count > 0{
        cell.placemark = searchResults[indexPath.row]
        }

                        
         return cell
     }
    
    
    

    
    
    

}



// MARK: - LocationInputViewDelegate

extension MapSearchViewController: LocationInputViewDelegate {

    
    func executeSearch(query: String) {
        searchBy(naturalLanguageQuery: query) { (results) in
            self.searchResults = results
        }
    }
}



private extension MapSearchViewController {
    func searchBy(naturalLanguageQuery: String, completion: @escaping([MKPlacemark]) -> Void) {
        var results = [MKPlacemark]()
        
        let request = MKLocalSearch.Request()
        request.region = mapView.region
        request.naturalLanguageQuery = naturalLanguageQuery
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else { return }
            
            response.mapItems.forEach({ item in
                results.append(item.placemark)
            })
            
            completion(results)
        }
    }
}



// MARK: -


