//
//  Filter_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 19/09/23.
//

import UIKit
import ObjectMapper

protocol FilterDataDelegate: AnyObject {
    func didFinishTask(data: String, type: String, name: String)
}


class Filter_VC: UIViewController {

    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var vw_rounded: RoundedTopCornersView!
    @IBOutlet weak var tbl_vw: UITableView!
    
    var arr_price: [String] = ["Popularity", "Price: Low to High", "Price: High to Low", "Name: A - Z", "Name: Z - A"]
    var arr_order: [String] = ["All Orders", "Pending", "In-Progress", "Delivered","Cancelled"]
    
    var arr_Category: [Categories] = []
    var isCategory = false
    var isOrder = false
    var selectOrder = String()
    var selectCategory = String()
    var selectPrice = String()
    var selected_Sort = String()
    weak var delegate: FilterDataDelegate?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbl_vw.register(UINib(nibName: "FilterCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tbl_vw.delegate = self
        self.tbl_vw.dataSource = self
        if selected_Sort == "All Orders"{
            UserDefaults.standard.removeObject(forKey: "selectOrder")
        }
//        UserDefaults.standard.removeObject(forKey: "selectOrder")
//        UserDefaults.standard.removeObject(forKey: "selectCategory")
//        UserDefaults.standard.removeObject(forKey: "selectPrice")
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isOrder {
            self.lbl_title.text = "Order Filter"
            if let str = UserDefaults.standard.value(forKey: "selectOrder") as? String {
                self.selectOrder = str
            } else {
                self.selectOrder = self.arr_order[0]
            }
            self.tbl_vw.reloadData()
        } else if isCategory {
            self.lbl_title.text = "Product Filter"
            if let str = UserDefaults.standard.value(forKey: "selectCategory") as? String {
                self.selectCategory = str
            }
            self.call_CategoriesAPI()
        } else {
            if let str = UserDefaults.standard.value(forKey: "selectPrice") as? String {
                self.selectPrice = str
            } else {
                let dict = self.arr_price[0]
                self.selectPrice = dict
            }
            self.lbl_title.text = "Product Sorting"
            self.tbl_vw.reloadData()
        }
    }
     
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != self.vw_rounded{
            self.dismiss(animated: true)
        }
    }
    
    //MARK:- API Call
    func call_CategoriesAPI() {
            
        let paramer: [String: Any] = [:]
        
        WebService.call.POSTT(filePath: global.shared.URL_Categories, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
            print(result)
            if let eventResponseModel:CategoryModel = Mapper<CategoryModel>().map(JSONObject: result) {
                if let arr = eventResponseModel.categories {
                    self.arr_Category = arr
                    self.tbl_vw.reloadData()
                }
            }
        }) {
            
        }
            
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension Filter_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var total = 0
        if self.isOrder {
            total = self.arr_order.count
        } else if self.isCategory {
            total = self.arr_Category.count + 1
        } else {
            total = self.arr_price.count
        }
        return total
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if self.isOrder {
            if let cell1 = self.tbl_vw.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FilterCell {
                let dict = self.arr_order[indexPath.row]
                cell1.lbl_title.text = dict
                if self.selectOrder == dict {
                    let image = UIImage(named: "Check") ?? UIImage()
                    cell1.btn_check.image = image
                } else {
                    let image = UIImage(named: "Uncheck") ?? UIImage()
                    cell1.btn_check.image = image
                }
                cell = cell1
            }
        } else if self.isCategory {
            if let cell1 = self.tbl_vw.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FilterCell {
                if indexPath.row == 0 {
                    cell1.lbl_title.text = "All Product"
                    if self.selectCategory == "All Product" {
                        let image = UIImage(named: "Check") ?? UIImage()
                        cell1.btn_check.image = image
                    } else {
                        let image = UIImage(named: "Uncheck") ?? UIImage()
                        cell1.btn_check.image = image
                    }
                } else {
                    let dict = self.arr_Category[indexPath.row - 1]
                    cell1.lbl_title.text = dict.category_Name
                    if self.selectCategory == (dict.category_Id ?? "") {
                        let image = UIImage(named: "Check") ?? UIImage()
                        cell1.btn_check.image = image
                    } else {
                        let image = UIImage(named: "Uncheck") ?? UIImage()
                        cell1.btn_check.image = image
                    }
                }
                cell = cell1
            }
        } else {
            if let cell1 = self.tbl_vw.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FilterCell {
                let name = self.arr_price[indexPath.row]
                cell1.lbl_title.text = name
                if self.selectPrice == name {
                    let image = UIImage(named: "Check") ?? UIImage()
                    cell1.btn_check.image = image
                } else {
                    let image = UIImage(named: "Uncheck") ?? UIImage()
                    cell1.btn_check.image = image
                }
                cell = cell1
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isOrder {
            let dict = self.arr_order[indexPath.row]
            self.selectOrder = dict
            UserDefaults.standard.set(self.selectOrder, forKey: "selectOrder")
            self.tbl_vw.reloadData()
            delegate?.didFinishTask(data: self.selectOrder, type: "Order", name: "")
            self.dismiss(animated: true)
        } else if self.isCategory {
            if indexPath.row == 0 {
                self.selectCategory = "All Product"
                UserDefaults.standard.set(self.selectCategory, forKey: "selectCategory")
                delegate?.didFinishTask(data: "0", type: "Category", name: "All Product")
            } else {
                let dict = self.arr_Category[indexPath.row-1]
                self.selectCategory = dict.category_Id ?? ""
                UserDefaults.standard.set(self.selectCategory, forKey: "selectCategory")
                delegate?.didFinishTask(data: self.selectCategory, type: "Category", name: dict.category_Name ?? "")
            }
            self.tbl_vw.reloadData()
            self.dismiss(animated: true)
        } else {
            let dict = self.arr_price[indexPath.row]
            self.selectPrice = dict
            UserDefaults.standard.set(self.selectPrice, forKey: "selectPrice")
            self.tbl_vw.reloadData()
            delegate?.didFinishTask(data: self.selectPrice, type: "Price", name: "")
            self.dismiss(animated: true)
        }
    }
    
}
