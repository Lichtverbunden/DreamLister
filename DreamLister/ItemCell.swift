//
//  ItemCell.swift
//  DreamLister
//
//  Created by Ken Krippeler on 17.07.17.
//  Copyright © 2017 Lichtverbunden. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell
{
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    
    let priceFormatter = NumberFormatter()
    
    func configureCell(item: Item)
    {
        priceFormatter.usesGroupingSeparator = true
        priceFormatter.locale = NSLocale.current
        priceFormatter.minimumIntegerDigits = 1
        priceFormatter.minimumFractionDigits = 0
        priceFormatter.maximumFractionDigits = 2
        
        let priceString = priceFormatter.string(from: (item.price as NSNumber))
      
        title.text = item.title
        price.text = "\(priceString!) €"
        details.text = item.details
        thumb.image = item.toImage?.image as? UIImage
    }
  
}
