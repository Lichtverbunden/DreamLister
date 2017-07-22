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
        
        launchTestData()
        attemptFetch()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath)
    {
        //Update Cell
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let objs = controller.fetchedObjects, objs.count > 0
        {
            let item = objs[indexPath.row]
            
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ItemDetailsVC"
        {
            if let destination = segue.destination as? ItemDetailsVC
            {
                if let item = sender as? Item
                {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let sections = controller.sections
        {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if let sections = controller.sections
        {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150
    }
    
    func attemptFetch()
    {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        //let typeFetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true, selector:#selector(NSString.localizedCaseInsensitiveCompare(_:)))
        let typeSort = NSSortDescriptor(key: "toItemType.type", ascending: true)
        
       
        if segment.selectedSegmentIndex == 0
        {
            fetchRequest.sortDescriptors = [dateSort]
        }
        else if segment.selectedSegmentIndex == 1
        {
            fetchRequest.sortDescriptors = [priceSort]
        }
        else if segment.selectedSegmentIndex == 2
        {
            fetchRequest.sortDescriptors = [titleSort]
        }
        else if segment.selectedSegmentIndex == 3
        {
            fetchRequest.sortDescriptors = [typeSort]
        }
        
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.controller = controller
        
        do
        {
            try controller.performFetch()
        }
        catch let error as NSError
        {
            print(error)
        }
    }
    
    @IBAction func segmentChange(_ sender: UISegmentedControl)
    {
        attemptFetch()
        tableView.reloadData()
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
                    configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
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
    
    func generateTestData()
    {
        let item = Item(context: context)
        
        item.title = "Kingdom Hearts III"
        item.price = 69.99
        item.details = "Kingdom Hearts 3 will end the Xehanort saga. Light and darkness will come together."
        
        let item2 = Item(context: context)
        
        item2.title = "Connection"
        item2.price = 0.00
        item2.details = "I wish to connect with life, with myself and others."
        
        let item3 = Item(context: context)
        
        item3.title = "Experience a waterfall"
        item3.price = 1000.00
        item3.details = "I wish to see, to hear, to feel a waterfall in this life."
        
        ad.saveContext()
    }
    
    func launchTestData()
    {
        let hasLaunchedKey = "HasLaunched"
        let defaults = UserDefaults.standard
        let hasLaunched = defaults.bool(forKey: hasLaunchedKey)
        
        if !hasLaunched
        {
            generateTestData()
            defaults.set(true, forKey: hasLaunchedKey)
        }
    }
    
    
}

