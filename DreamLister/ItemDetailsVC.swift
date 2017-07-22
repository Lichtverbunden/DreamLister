//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Ken Krippeler on 20.07.17.
//  Copyright © 2017 Lichtverbunden. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var detailsField: UITextField!
    @IBOutlet weak var thumbImg: UIImageView!
    
    var stores: [Store] = []
    var types: [ItemType] = []
    var itemToEdit: Item?
    var typesToEdit: ItemType?
    var imagePicker: UIImagePickerController!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem
        {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        priceField.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        launchStoresAndTypes()
        
        getStores()
        getTypes()
        
        if itemToEdit != nil
        {
            loadItemData()
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if component == 0
        {
            let store = stores[row]
            
            return store.name
        }
        else
        {
            let type = types[row]
            
            return type.type
        }
        
       
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if component == 0
        {
            return stores.count
        }
        else
        {
            return types.count
        }
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
    }

    func getStores()
    {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do
        {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        }
        catch let error as NSError
        {
            print(error)
        }

    }
    
    func getTypes()
    {
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do
        {
            self.types = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        }
        catch let error as NSError
        {
            print(error)
        }
        
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = "01234567890."
        
        if string.characters.count == 0
        {
            return true
        }
        
        if textField == self.priceField
        {
            let cs = CharacterSet(charactersIn: allowedCharacters)
            let filtered = string.components(separatedBy: cs).filter
            {
                !$0.isEmpty
            }
            let str = filtered.joined(separator: "")
            
            return (string != str)
        }
        
        return true
    }
    
    @IBAction func savePressed(_ sender: UIButton)
    {
        var item: Item!
        let picture = Image(context: context)
        
        picture.image = thumbImg.image
        
        if itemToEdit == nil
        {
            item = Item(context: context)
        }
        else
        {
            item = itemToEdit
        }
        
         item.toImage = picture
        
        if let title = titleField.text
        {
            item.title = title
        }
        
        if let price = priceField.text
        {
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text
        {
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        item.toItemType = types[storePicker.selectedRow(inComponent: 1)]
        
        ad.saveContext()
        
       _ = navigationController?.popViewController(animated: true)
    }
    
    func loadItemData()
    {
        if let item = itemToEdit
        {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            
            thumbImg.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore
            {
                var index = 0
                repeat
                {
                    let s = stores[index]
                    if s.name == store.name
                    {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                    
                } while (index < stores.count)
            }
            
            if let type = item.toItemType
            {
                var index = 0
                repeat
                {
                    let t = types[index]
                    if t.type == type.type
                    {
                        storePicker.selectRow(index, inComponent: 1, animated: false)
                        break
                    }
                    index += 1
                    
                } while (index < types.count)
            }

        }
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem)
    {
        if itemToEdit != nil
        {
            let alert = UIAlertController(title: "Remove Wish", message: "Do you really want to delete your wish out of the app?", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
                context.delete(self.itemToEdit!)
                ad.saveContext()
                
                _ = self.navigationController?.popViewController(animated: true)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
                //Nothing will happen
            })
            
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        }
        
       
    }

    @IBAction func addImage(_ sender: UIButton)
    {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            thumbImg.image = image
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func setStores()
    {
        let store = Store(context: context)
        store.name = "None"
        let store2 = Store(context: context)
        store2.name = "Amazon"
        let store3 = Store(context: context)
        store3.name = "HiFi"
        let store4 = Store(context: context)
        store4.name = "Saturn"
        let store5 = Store(context: context)
        store5.name = "Apple"
        let store6 = Store(context: context)
        store6.name = "GameStop"
        let store7 = Store(context: context)
        store7.name = "Media Markt"
        
        ad.saveContext()
    }
    
    func setTypes()
    {
        let type = ItemType(context: context)
        type.type = "Electronics"
        let type2 = ItemType(context: context)
        type2.type = "Games"
        let type3 = ItemType(context: context)
        type3.type = "Experiences"
        let type4 = ItemType(context: context)
        type4.type = "Movies"
        
        ad.saveContext()
    }
    
    func launchStoresAndTypes()
    {
        let hasLaunchedStoresAndTypesKey = "HasLaunchedStoresAndTypes"
        let defaults = UserDefaults.standard
        let hasLaunchedStoresAndTypes = defaults.bool(forKey: hasLaunchedStoresAndTypesKey)
        
        if !hasLaunchedStoresAndTypes
        {
            setStores()
            setTypes()
            defaults.set(true, forKey: hasLaunchedStoresAndTypesKey)
        }
    }

    
    
}
