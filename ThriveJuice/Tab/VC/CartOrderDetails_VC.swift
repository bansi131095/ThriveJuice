//
//  CartOrderDetails_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 18/08/23.
//

import UIKit
import ObjectMapper
import FSCalendar


class CartOrderDetails_VC: UIViewController {

    
    @IBOutlet weak var txt_Note: UITextField!
    @IBOutlet weak var btn_OTPurchase: UIButton!
    @IBOutlet weak var btn_Subscribe: UIButton!
    @IBOutlet weak var lbl_Subscription: UILabel!
    @IBOutlet weak var vw_Subscribe: UIView!
    @IBOutlet weak var vw_height_subscribe: NSLayoutConstraint!
    @IBOutlet weak var txt_week: UITextField!
    @IBOutlet weak var txt_DeliveryDate: UITextField!
    @IBOutlet weak var txt_TimeSlot: UITextField!
    @IBOutlet weak var vw_Calendar: UIView!
    @IBOutlet weak var lbl_year: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var tbl_height_const: NSLayoutConstraint!
    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var btn_localPickup: UIButton!
    @IBOutlet weak var btn_storePickup: UIButton!
    @IBOutlet weak var btn_pickupToday: UIButton!
    @IBOutlet weak var vw_TimeSlot: UIView!
    @IBOutlet weak var vw_timeHeight_const: NSLayoutConstraint!
    @IBOutlet weak var btn_store: UIButton!
    @IBOutlet weak var btn_storeHeight_const: NSLayoutConstraint!
    @IBOutlet weak var vw_addressTitle: UIView!
    @IBOutlet weak var vw_addressTitle_height_const: NSLayoutConstraint!
    @IBOutlet weak var vw_address: UIView!
    @IBOutlet weak var lbl_deliveryDate: UILabel!
    @IBOutlet weak var vw_deliveryDate: UIView!
    @IBOutlet weak var vw_deliveryDateHeight_const: NSLayoutConstraint!
    @IBOutlet weak var vw_TimeSlots: UIView!
    @IBOutlet weak var vw_timeSlotsHeight_const: NSLayoutConstraint!
    @IBOutlet weak var btn_checkOut: UIButton!
    @IBOutlet weak var btn_checkout_height_const: NSLayoutConstraint!
    
    
    var selectDeliverDate = String()
    var selectDeliverTime = String()
    var arr_time: [Time_Slots] = []
    var arr_ActiveTime: [Active_Dates_Slots] = []
    var arr_subscription: [Subscribe_Weeks] = []
    var arr_Address: [Addresses] = []
    var arr_Store: [Stores] = []
    var arrSelectedStore: [Selected_Stores] = []
    
    let pickerSubscription = UIPickerView()
    let pickerTimeSlot = UIPickerView()
    var selectedStartDate: Date?
    var selectedEndDate: Date?
    var disableDates: [String] = []
    var minimumDate: Date!
    var maximumDate: Date!
    var selectDate: Date!
    var OrderType = String()
    var SubscribeWeek = String()

    
//    lazy var  calenderView: CalenderView = {
//        let calenderView = CalenderView(theme: MyTheme.light)
//        calenderView.translatesAutoresizingMaskIntoConstraints = false
//        return calenderView
//    }()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy"
        self.lbl_year.text = dateFormate.string(from: Date())
        self.vw_TimeSlot.isHidden = true
        self.vw_timeHeight_const.constant = 0.0
        var orderType = String()
        if UserDefaults.standard.object(forKey: "orderType") != nil {
            orderType = UserDefaults.standard.string(forKey: "orderType") ?? ""
        }
        self.OrderType = orderType
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.call_ProfileAPI()
        self.call_CartAPI(str_data: false)
        
    }
    
    
    //MARK:- Button Action
    @IBAction func act_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func act_changeStore(_ sender: UIButton) {
        let store = self.storyboard?.instantiateViewController(withIdentifier: "StoreList_VC") as! StoreList_VC
        self.navigationController?.pushViewController(store, animated: true)
    }
    
    @IBAction func act_ChangeAddress(_ sender: UIButton) {
        let address = self.storyboard?.instantiateViewController(withIdentifier: "AddressList_VC") as! AddressList_VC
        self.navigationController?.pushViewController(address, animated: true)
    }
    
    @IBAction func act_CheckOut(_ sender: UIButton) {
        if self.OrderType == "Right_Away" {
            let Data = OrderData(deliveryDate: "", subscribeWeek: (self.btn_Subscribe.currentImage?.pngData() == UIImage(named: "Check")?.pngData()) ? (self.SubscribeWeek) : "", orderType: self.OrderType, deliveryTime: self.selectDeliverTime, orderNotes: self.txt_Note.text ?? "")
            let OrderSummary = self.storyboard?.instantiateViewController(withIdentifier: "OrderSummary_VC") as! OrderSummary_VC
            OrderSummary.OrderData_dict = Data
            self.navigationController?.pushViewController(OrderSummary, animated: true)
        } else if self.txt_DeliveryDate.text == "" {
            self.showAlertToast(message: "Please Select Date")
        } else {
            var SelectDate = String()
            if let date = self.txt_DeliveryDate.text {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                if let s = dateFormatter.date(from: date) {
                    //CONVERT FROM NSDate to String
                    let dateFormatter1 = DateFormatter()
                    dateFormatter1.dateFormat = "yyyy-MM-dd"
                    let dateString = dateFormatter1.string(from: s)
                    dateFormatter1.locale = NSLocale.init(localeIdentifier: "en") as Locale
                    SelectDate = dateString
//                        self.txt_DeliveryDate.text = dateString
                }
            }
            let Data = OrderData(deliveryDate: SelectDate, subscribeWeek: (self.btn_Subscribe.currentImage?.pngData() == UIImage(named: "Check")?.pngData()) ? (self.SubscribeWeek) : "", orderType: self.OrderType, deliveryTime: self.selectDeliverTime, orderNotes: self.txt_Note.text ?? "")
            let OrderSummary = self.storyboard?.instantiateViewController(withIdentifier: "OrderSummary_VC") as! OrderSummary_VC
            OrderSummary.OrderData_dict = Data
            self.navigationController?.pushViewController(OrderSummary, animated: true)
        }
    }
    
    @IBAction func act_OTPurchase(_ sender: UIButton) {
        self.btn_OTPurchase.setImage(UIImage(named: "Check"), for: .normal)
        self.btn_Subscribe.setImage(UIImage(named: "Uncheck"), for: .normal)
        self.vw_Subscribe.isHidden = true
        self.vw_height_subscribe.constant = 0.0
    }
    
    @IBAction func act_Subscribe(_ sender: UIButton) {
        self.btn_Subscribe.setImage(UIImage(named: "Check"), for: .normal)
        self.btn_OTPurchase.setImage(UIImage(named: "Uncheck"), for: .normal)
        self.vw_Subscribe.isHidden = false
        self.vw_height_subscribe.constant = 40.0
        self.call_CartAPI(str_data: true)
    }
    
    @IBAction func act_localPickup(_ sender: UIButton) {
        self.btn_localPickup.setImage(UIImage(named: "Check"), for: .normal)
        self.btn_storePickup.setImage(UIImage(named: "Uncheck"), for: .normal)
        self.btn_pickupToday.setImage(UIImage(named: "Uncheck"), for: .normal)
        self.tbl_vw.isHidden = true
        self.tbl_height_const.constant = 0.0
        self.btn_store.isHidden = true
        self.btn_storeHeight_const.constant = 0.0
        self.vw_addressTitle.isHidden = false
        self.vw_addressTitle_height_const.constant = 32.0
        self.vw_address.isHidden = false
        for i in 0..<self.arr_Address.count {
            if let select = self.arr_Address[i].is_Selected {
                if select {
                    self.lbl_Address.text = self.arr_Address[i].address
                }
            }
        }
        self.lbl_Address.isHidden = false
        self.lbl_deliveryDate.text = "Delivery Date & Time"
        self.vw_deliveryDate.isHidden = false
        self.vw_deliveryDateHeight_const.constant = 85.0
        self.vw_TimeSlots.isHidden = true
        self.vw_timeSlotsHeight_const.constant = 0.0
        self.OrderType = "Local_Delivery"
        self.call_CartAPI(str_data: true)
    }
    
    @IBAction func act_storePickup(_ sender: UIButton) {
        self.btn_storePickup.setImage(UIImage(named: "Check"), for: .normal)
        self.btn_localPickup.setImage(UIImage(named: "Uncheck"), for: .normal)
        self.btn_pickupToday.setImage(UIImage(named: "Uncheck"), for: .normal)
        self.tbl_vw.isHidden = false
        self.tbl_height_const.constant = CGFloat(self.arrSelectedStore.count*110)
        self.btn_store.isHidden = false
        self.btn_storeHeight_const.constant = 32.0
        self.vw_addressTitle.isHidden = true
        self.vw_addressTitle_height_const.constant = 0.0
        self.vw_address.isHidden = true
        self.lbl_Address.text = ""
        self.lbl_Address.isHidden = true
        self.lbl_deliveryDate.text = "Delivery Date & Time"
        self.vw_deliveryDate.isHidden = false
        self.vw_deliveryDateHeight_const.constant = 85.0
        self.vw_TimeSlots.isHidden = true
        self.vw_timeSlotsHeight_const.constant = 0.0
        self.OrderType = "Store_Pickup"
        self.call_CartAPI(str_data: true)
    }
    
    @IBAction func act_pickupToday(_ sender: UIButton) {
        self.btn_pickupToday.setImage(UIImage(named: "Check"), for: .normal)
        self.btn_localPickup.setImage(UIImage(named: "Uncheck"), for: .normal)
        self.btn_storePickup.setImage(UIImage(named: "Uncheck"), for: .normal)
        self.tbl_vw.isHidden = false
        self.tbl_height_const.constant = CGFloat(self.arrSelectedStore.count*110)
        self.btn_store.isHidden = false
        self.btn_storeHeight_const.constant = 32.0
        self.vw_addressTitle.isHidden = true
        self.vw_addressTitle_height_const.constant = 0.0
        self.vw_address.isHidden = true
        self.lbl_Address.text = ""
        self.lbl_Address.isHidden = true
        self.lbl_deliveryDate.text = ""
        self.vw_deliveryDate.isHidden = true
        self.vw_deliveryDateHeight_const.constant = 0.0
        self.vw_TimeSlots.isHidden = true
        self.vw_timeSlotsHeight_const.constant = 0.0
        self.OrderType = "Right_Away"
        self.call_CartAPI(str_data: true)
    }
    
    @IBAction func act_OK(_ sender: UIButton) {
        self.vw_Calendar.isHidden = true
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd-MM-yyyy"
        dateFormatter1.locale = NSLocale.init(localeIdentifier: "en") as Locale
        let dateString = dateFormatter1.string(from: self.selectDate)
        self.txt_DeliveryDate.text = dateString
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        dateFormatter2.locale = NSLocale.init(localeIdentifier: "en") as Locale
        let dateString1 = dateFormatter2.string(from: self.selectDate)
        let arr = self.arr_ActiveTime.filter {$0.date == dateString1}
        if arr.count != 0 {
            if let data = arr[0].time_Slots {
                self.arr_time = data
            }
        }
        self.vw_TimeSlot.isHidden = false
        self.vw_timeHeight_const.constant = 90.0
        self.txt_TimeSlot.text = self.arr_time[0].time_Slot_Display ?? "0"
        self.selectDeliverTime = self.arr_time[0].time_Slot ?? "0"
        self.pickerTimeSlot.reloadAllComponents()
//        if global.shared.arr_cartId.count != 0 {
//            let str = global.shared.arr_cartId.joined(separator: ",")
//            self.call_ScheduleList_WS(CartData: str, isShowStart_Date: false)
//        }
    }
    
    @IBAction func act_CANCEL(_ sender: UIButton) {
        self.vw_Calendar.isHidden = true
    }
    
    
    //MARK:- API Call
    func call_CartAPI(str_data: Bool) {
        let arrCartData = global.shared.arr_AddCartData
        var JsonData_Cart = String()
        do {
            let jsonData = try JSONEncoder().encode(arrCartData)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonData)
            print(jsonString) // [{"sentence":"Hello world","lang":"en"},{"sentence":"Hallo Welt","lang":"de"}]
            JsonData_Cart = jsonString
            // and decode it back
//            let decodedSentences = try JSONDecoder().decode([Commodity_Qty].self, from: jsonData)
//            print(decodedSentences)
        } catch { print(error) }
        
        var paramer: [String: Any] = [:]
        if str_data {
            paramer["Cart_Data"] = JsonData_Cart
            paramer["Order_Type"] = self.OrderType
            if self.btn_Subscribe.currentImage?.pngData() == UIImage(named: "Check")?.pngData() {
                paramer["Subscribe_Week"] = SubscribeWeek
            }
        } else {
            paramer["Cart_Data"] = JsonData_Cart
        }
        
        WebService.call.POSTT(filePath: global.shared.URL_Cart, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
            print(result)
            if let eventResponseModel:CartModel = Mapper<CartModel>().map(JSONObject: result) {
                if let arr = eventResponseModel.stores, arr.count != 0 {
                    self.arr_Store = arr
                    self.arrSelectedStore.removeAll()
                    if let storeId = eventResponseModel.selected_Stores {
                        self.arrSelectedStore.append(storeId)
                    }
                    self.tbl_vw.register(UINib(nibName: "StoreList_cell", bundle: nil), forCellReuseIdentifier: "cell")
                    self.tbl_vw.delegate = self
                    self.tbl_vw.dataSource = self
                    if self.OrderType != "Local_Delivery" {
                        self.tbl_vw.isHidden = false
                        self.tbl_height_const.constant = CGFloat(self.arr_Store.count*110)
                    } else {
                        self.tbl_height_const.constant = 0.0
                        self.tbl_vw.isHidden = true
                    }
                    self.tbl_vw.reloadData()
                }
                if let arr = eventResponseModel.subscribe_Weeks, arr.count != 0 {
                    self.arr_subscription = arr
                    self.pickerSubscription.delegate = self
                    self.pickerSubscription.dataSource = self
                    // Assign the picker view as the input view for the text field
                    self.txt_week.inputView = self.pickerSubscription
                    if self.SubscribeWeek == "" {
                        self.txt_week.text = self.arr_subscription[0].subscribe_Week_Display ?? ""
                        self.SubscribeWeek = self.arr_subscription[0].subscribe_Week ?? ""
                    }
                }
                if let SubscribeAmount = eventResponseModel.subscribe_Amount {
                    self.lbl_Subscription.text = "Subscribe & Save 10% ($" + SubscribeAmount + ")"
                }
                if self.OrderType == "Local_Delivery" {
                    self.btn_localPickup.setImage(UIImage(named: "Check"), for: .normal)
                    self.btn_storePickup.setImage(UIImage(named: "Uncheck"), for: .normal)
                    self.btn_pickupToday.setImage(UIImage(named: "Uncheck"), for: .normal)
                    self.tbl_vw.isHidden = true
                    self.tbl_height_const.constant = 0.0
                    self.btn_store.isHidden = true
                    self.btn_storeHeight_const.constant = 0.0
                    self.vw_addressTitle.isHidden = false
                    self.vw_addressTitle_height_const.constant = 32.0
                    self.vw_address.isHidden = false
                    for i in 0..<self.arr_Address.count {
                        if let select = self.arr_Address[i].is_Selected {
                            if select {
                                self.lbl_Address.text = self.arr_Address[i].address
                            }
                        }
                    }
                    self.lbl_Address.isHidden = false
                    self.lbl_deliveryDate.text = "Delivery Date & Time"
                    self.vw_deliveryDate.isHidden = false
                    self.vw_deliveryDateHeight_const.constant = 85.0
                } else if self.OrderType == "Store_Pickup" {
                    self.btn_storePickup.setImage(UIImage(named: "Check"), for: .normal)
                    self.btn_localPickup.setImage(UIImage(named: "Uncheck"), for: .normal)
                    self.btn_pickupToday.setImage(UIImage(named: "Uncheck"), for: .normal)
                    self.tbl_vw.isHidden = false
                    self.tbl_height_const.constant = CGFloat(self.arrSelectedStore.count*110)
                    self.btn_store.isHidden = false
                    self.btn_storeHeight_const.constant = 32.0
                    self.vw_addressTitle.isHidden = true
                    self.vw_addressTitle_height_const.constant = 0.0
                    self.vw_address.isHidden = true
                    self.lbl_Address.text = ""
                    self.lbl_Address.isHidden = true
                    self.lbl_deliveryDate.text = "Delivery Date & Time"
                    self.vw_deliveryDate.isHidden = false
                    self.vw_deliveryDateHeight_const.constant = 85.0
                } else if self.OrderType == "Right_Away" {
                    self.btn_pickupToday.setImage(UIImage(named: "Check"), for: .normal)
                    self.btn_localPickup.setImage(UIImage(named: "Uncheck"), for: .normal)
                    self.btn_storePickup.setImage(UIImage(named: "Uncheck"), for: .normal)
                    self.tbl_vw.isHidden = false
                    self.tbl_height_const.constant = CGFloat(self.arrSelectedStore.count*110)
                    self.btn_store.isHidden = false
                    self.btn_storeHeight_const.constant = 32.0
                    self.vw_addressTitle.isHidden = true
                    self.vw_addressTitle_height_const.constant = 0.0
                    self.vw_address.isHidden = true
                    self.lbl_Address.text = ""
                    self.lbl_Address.isHidden = true
                    self.lbl_deliveryDate.text = ""
                    self.vw_deliveryDate.isHidden = true
                    self.vw_deliveryDateHeight_const.constant = 0.0
                }
                
            }
            self.call_ScheduleDateAPI()
        }) {
            
        }
            
    }
    
    
    func call_ScheduleDateAPI() {
            
        // Offset, Type= Category, Category_Id, Product_Id
        var paramer: [String: Any] = [:]
        paramer["Order_Type"] = self.OrderType
        
        WebService.call.POSTT(filePath: global.shared.URL_Schedule_Dates, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:ScheduleDatesModel = Mapper<ScheduleDatesModel>().map(JSONObject: result) {
                if let date = eventResponseModel.start_Date {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    if let s = dateFormatter.date(from: date) {
                        self.minimumDate = s
                        self.selectDate = s
//                        self.txt_DeliveryDate.text = dateString
                    }
                }
                if let date = eventResponseModel.end_Date {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    if let s = dateFormatter.date(from: date) {
                        //CONVERT FROM NSDate to String
                        self.maximumDate = s
                    }
                }
                if let arr = eventResponseModel.deActive_Dates, arr.count != 0 {
                    for i in 0..<arr.count {
                        self.disableDates.append(arr[i])
                    }
                }
                if let arr = eventResponseModel.active_Dates_Slots, arr.count != 0 {
                    self.arr_ActiveTime = arr
                    self.pickerTimeSlot.delegate = self
                    self.pickerTimeSlot.dataSource = self
                    self.txt_TimeSlot.inputView = self.pickerTimeSlot
                }
                if self.OrderType == "Right_Away" {
                    if let arr = eventResponseModel.pickup_Slots, arr.count != 0 {
                        self.arr_time = arr
                        self.vw_TimeSlot.isHidden = false
                        self.vw_timeHeight_const.constant = 90.0
                        self.vw_TimeSlots.isHidden = true
                        self.vw_timeSlotsHeight_const.constant = 0.0
                        self.txt_TimeSlot.text = self.arr_time[0].time_Slot_Display ?? "0"
                        self.selectDeliverTime = self.arr_time[0].time_Slot ?? "0"
                        self.pickerTimeSlot.reloadAllComponents()
                        self.btn_checkOut.isHidden = false
                        self.btn_checkout_height_const.constant = 44.0
                    } else {
                        self.vw_TimeSlots.isHidden = false
                        self.vw_timeSlotsHeight_const.constant = 45.0
                        self.vw_TimeSlot.isHidden = true
                        self.vw_timeHeight_const.constant = 0.0
                        self.btn_checkOut.isHidden = true
                        self.btn_checkout_height_const.constant = 0.0
                    }
                } else {
                    self.vw_TimeSlots.isHidden = true
                    self.vw_timeSlotsHeight_const.constant = 0.0
                    self.vw_TimeSlot.isHidden = true
                    self.vw_timeHeight_const.constant = 0.0
                    self.btn_checkOut.isHidden = false
                    self.btn_checkout_height_const.constant = 44.0
                }
                calendar.delegate = self
                calendar.dataSource = self
                // Set the calendar appearance (optional)
                calendar.appearance.weekdayTextColor = .black
                calendar.scope = .month
//                calendar.select(self.minimumDate)
                calendar.select(self.minimumDate, scrollToDate: true)
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "E, dd MMM"
                dateFormatter1.locale = NSLocale.init(localeIdentifier: "en") as Locale
                let dateString = dateFormatter1.string(from: self.minimumDate)
                self.lbl_date.text = dateString
                calendar.reloadData()
            }
        }) {
            
        }
    }
    
    
    func call_ProfileAPI() {
            
        // Offset, Type= Category, Category_Id, Product_Id
        let paramer: [String: Any] = [:]
        
        WebService.call.POSTT(filePath: global.shared.URL_Profile, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:ProfileModel = Mapper<ProfileModel>().map(JSONObject: result) {
                if let address = eventResponseModel.user?.addresses, address.count != 0 {
                    self.arr_Address = address
                    for i in 0..<self.arr_Address.count {
                        if let select = self.arr_Address[i].is_Selected {
                            if select {
                                self.lbl_Address.text = self.arr_Address[i].address
                            }
                        }
                    }
                }
            }
        }) {
            
        }
            
    }
    
    fileprivate func showAlert(){
        let alert = UIAlertController(title: "Unavailable", message: "This slot is already booked.\nPlease choose another date.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
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


extension CartOrderDetails_VC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txt_DeliveryDate {
            textField.endEditing(true)
            self.vw_Calendar.isHidden = false
        }
    }
    
}

extension CartOrderDetails_VC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    func minimumDate(for calendar: FSCalendar) -> Date {
        // Return your minimum date here
        return minimumDate
    }

    func maximumDate(for calendar: FSCalendar) -> Date {
        // Return your maximum date here
        return maximumDate
    }

    // Other delegate methods
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        // Check if the selected date is within the defined range
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        dateFormatter1.locale = NSLocale.init(localeIdentifier: "en") as Locale
        let dateString = dateFormatter1.string(from: date)
        if date >= minimumDate && date <= maximumDate {
            if (self.disableDates.contains(dateString)) {
                return false
            } else {
                self.selectDate = date
                self.lbl_date.text = dateString
                let arr = self.arr_ActiveTime.filter {$0.date == dateString}
                if arr.count != 0 {
                    if let data = arr[0].time_Slots {
                        self.arr_time = data
                    }
                }
                self.vw_TimeSlot.isHidden = false
                self.vw_timeHeight_const.constant = 90.0
                self.txt_TimeSlot.text = self.arr_time[0].time_Slot_Display ?? "0"
                self.selectDeliverTime = self.arr_time[0].time_Slot ?? "0"
                self.pickerTimeSlot.reloadAllComponents()
                return true
            }
        }
        return false
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // Handle the selected date within the valid range
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        print("titleDefaultColorFor called for date: \(date)")
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        dateFormatter1.locale = NSLocale.init(localeIdentifier: "en") as Locale
        let dateString = dateFormatter1.string(from: date)
        if self.minimumDate <= date && date <= self.maximumDate {
            if (self.disableDates.contains(dateString)) {
                return .lightGray
            } else {
                return nil
            }
        } else {
            return .lightGray // Color for disabled dates
        }
    }
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, shouldUseCustomColorFor date: Date) -> Bool {
//        let startDate = self.minimumDate ?? Date()// Your start date for the range
//        let endDate = self.maximumDate ?? Date()// Your end date for the range
//
//        if date <= startDate && date <= endDate {
//            // Set a custom color for dates within the range
//            appearance.titleDefaultColor = .black // Replace with your custom color
//        } else {
//            // Set the default text color for other dates
//            appearance.titleDefaultColor = .lightGray // Replace with your default color
//        }
//
//        return true
//    }

}


extension CartOrderDetails_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSelectedStore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? StoreList_cell {
            let dict = self.arrSelectedStore[indexPath.row]
            cell.lbl_Name.text = dict.name
            cell.lbl_Address.text = dict.store_Address
            cell.lbl_City.text = (dict.store_City ?? "") + " - " + (dict.store_Postal_Code ?? "")
            cell.vw_card.borderColor = UIColor(named: "AccentColor")
            return cell
        }
        return UITableViewCell()
    }
    
}


extension CartOrderDetails_VC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Number of components in the picker view (columns)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var total = 0
        if pickerView == self.pickerSubscription {
            total = self.arr_subscription.count
        } else if pickerView == self.pickerTimeSlot {
            total = self.arr_time.count
        }
        return total // Replace with the actual data source count
    }
    
    // Content for each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var str = ""
        if pickerView == self.pickerSubscription {
            str = self.arr_subscription[row].subscribe_Week_Display ?? ""
        } else if pickerView == self.pickerTimeSlot {
            str = self.arr_time[row].time_Slot_Display ?? ""
        }
        return str // Replace with the actual data
    }
    
    // Handle selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.pickerSubscription {
            self.txt_week.text = self.arr_subscription[row].subscribe_Week_Display ?? ""
            self.SubscribeWeek = self.arr_subscription[row].subscribe_Week ?? ""
            self.call_CartAPI(str_data: true)
        } else if pickerView == self.pickerTimeSlot {
            self.txt_TimeSlot.text = self.arr_time[row].time_Slot_Display ?? ""
            self.selectDeliverTime = self.arr_time[row].time_Slot ?? "0"
        }
        self.view.endEditing(true)
    }
    
}
