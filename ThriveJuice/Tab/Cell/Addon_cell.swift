//
//  Addon_cell.swift
//  ThriveJuice
//
//  Created by MacBook on 26/10/23.
//

import UIKit

class Addon_cell: UITableViewCell {

    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var collect_vw: UICollectionView!
    @IBOutlet weak var collect_height_const: NSLayoutConstraint!
    
    
    var arr_AddonItem: [Addons] =  []
    var selectAddonId: [String] = []
    var CollectionHeight = 0
    var selectType: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var Act_AddAddon:((_ str:String, _ old: String, _ add: Bool)->Void)?
    
    func SetCollectVw() {
        self.collect_vw.register(UINib(nibName: "Addon_list_coll_cell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.collect_vw.delegate = self
        self.collect_vw.dataSource = self
        let spacing: CGFloat = 0 // Set your desired spacing value
        if let layout = self.collect_vw.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = spacing
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
    }
    
}

extension Addon_cell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr_AddonItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collect_vw.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Addon_list_coll_cell
        let data = self.arr_AddonItem[indexPath.item]
        if let name = data.addon_Name, let price = data.addon_Price {
            cell.lbl_Addon.text = name + " - $" + price
        }
        if let id = data.addon_Id {
            if self.selectAddonId.contains(id) {
                cell.vw_Addon.backgroundColor = UIColor(named: "AccentColor")
                cell.lbl_Addon.textColor = UIColor(named: "White")
            } else {
                cell.vw_Addon.backgroundColor = UIColor(named: "White")
                cell.lbl_Addon.textColor = UIColor(named: "AccentColor")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.arr_AddonItem[indexPath.item]
        if self.selectType == "Single" {
            if let id = data.addon_Id {
                if self.selectAddonId.count != 0 {
                    if self.selectAddonId.contains(id) {
                        if let indexes = self.selectAddonId.firstIndex(of: id) {
                            self.selectAddonId.remove(at: indexes)
                            self.Act_AddAddon?(id, "", false)
                        }
                    } else {
                        let last = self.selectAddonId.last ?? ""
                        self.selectAddonId = []
                        self.selectAddonId.append(id)
                        self.Act_AddAddon?(id, last,true)
                    }
                } else {
                    self.selectAddonId.append(id)
                    self.Act_AddAddon?(id, "", true)
                }
            }
        } else {
            if let id = data.addon_Id {
                if self.selectAddonId.count != 0 {
                    if self.selectAddonId.contains(id) {
                        if let indexes = self.selectAddonId.firstIndex(of: id) {
                            self.selectAddonId.remove(at: indexes)
                            self.Act_AddAddon?(id, "", false)
                        }
                    } else {
                        self.selectAddonId.append(id)
                        self.Act_AddAddon?(id, "", true)
                    }
                } else {
                    self.selectAddonId.append(id)
                    self.Act_AddAddon?(id, "", true)
                }
            }
        }
        self.collect_vw.reloadData()
    }
    

}
