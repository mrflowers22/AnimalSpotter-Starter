//
//  AnimalsTableViewController.swift
//  AnimalSpotter
//
//  Created by Ben Gohlke on 4/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class AnimalsTableViewController: UITableViewController {
    
    let ac = APIController()
    private var animalNames: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // transition to login view if conditions require
        if ac.bearer == nil {
            //we must not be logged in becuase we need this token/bearer
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animalNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = animalNames[indexPath.row]

        return cell
    }

    // MARK: - Actions
    @IBAction func getAnimals(_ sender: UIBarButtonItem) {
        // fetch all animals from API
        ac.fetchAllAnimalNames { (result) in
            if let names = try? result.get() { //try and get the success value and bind it to names constant
                DispatchQueue.main.async {
                    self.animalNames = names
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAnimalDetailSegue" {
            // inject dependencies
            if let detailVC = segue.destination as? AnimalDetailViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    detailVC.animalName = animalNames[indexPath.row]
                }
                detailVC.apiController = ac
            }
        }
        else if segue.identifier == "LoginViewModalSegue" {
            // inject dependencies
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.apiController = ac
            }
        }
    }
}
