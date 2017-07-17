//
//  MainVC.swift
//  DreamLister
//
//  Created by Ken Krippeler on 17.07.17.
//  Copyright © 2017 Lichtverbunden. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var controller: NSFetchedResultsController<Item>!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 0
    }
    
    func attemptFetch()
    {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        
        fetchRequest.sortDescriptors = [dateSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do
        {
            try controller.performFetch()
        }
        catch let error as NSError
        {
            print(error)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch(type)
        {
            case.insert:
                if let indexPath = newIndexPath
                {
                    tableView.insertRows(at: [indexPath], with: .fade)
                }
                break
            
            case.delete:
                if let indexPath = indexPath
                {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                break
            
            case.update:
                if let indexPath = indexPath
                {
                    let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                    
                    //Update the cell data
                    
                }
                break
            
            case.move:
                if let indexPath = indexPath
                {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            
                if let indexPath = newIndexPath
                {
                    tableView.insertRows(at: [indexPath], with: .fade)
                }
                break
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}

