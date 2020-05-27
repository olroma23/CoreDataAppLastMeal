//
//  MainTableViewController.swift
//  LastTimeMeal
//
//  Created by Roman Oliinyk on 24.05.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {
    
    var context: NSManagedObjectContext!
    var user: User!
    
    lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Meal Time"
        
        let userName = "Roman"
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", userName)
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                user = User(context: context)
                user.name = userName
                try context.save()
            } else {
                user = results.first
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        let meal = Meal(context: context)
        meal.date = Date()
        
        let meals = user.meals?.mutableCopy() as? NSMutableOrderedSet
        meals?.add(meal)
        user.meals = meals
        
        do {
            try context.save()
            tableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return user.meals?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        guard let meal = user.meals?[indexPath.row] as? Meal,
            let mealDate = meal.date
            else { return cell }
        
        cell.textLabel?.text = dateFormatter.string(from: mealDate)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let meal = user.meals?[indexPath.row] as? Meal else { return }
            context.delete(meal)
            
            do {
                try context.save()
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}
