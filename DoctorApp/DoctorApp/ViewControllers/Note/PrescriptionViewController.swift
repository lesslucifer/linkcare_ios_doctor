//
//  PrescriptionViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 5/7/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import PKHUD

protocol PrescriptionViewControllerDelegate {
    func goBack()
}

class PrescriptionViewController: UIViewController {
    var appointmentId: Int!
    
    @IBOutlet var tbPrescription: UITableView!
    @IBOutlet var btnEdit: UIBarButtonItem!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var listPrescription = [PrescriptionMedicine()]
    private var vdataPicker: DataPicker!
    private var listPickerdata: Array<String>!
    
    var delegate: PrescriptionViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.dismissKeyboardOnTap()

        self.configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        btnSubmit.linkcarelize()
    }

    func addPrescription(){
        self.view.endEditing(true)
        
        let newPrescription = PrescriptionMedicine()
        listPrescription.append(newPrescription)
        
        tbPrescription.reloadData()
        
    }
    
    @IBAction func submit(sender: UIButton) {
        self.view.endEditing(true)
        
        if !self.validateInput() {
            Utils.showOKAlertPanel(self, title: "Rất tiếc...", msg: "Vui lòng điền các trường còn thiếu (tên thuốc, số lượng thuốc)")
            return
        }
        
        let currentDate = NSDate()
        
        let prescription = Prescription()
        prescription.appointmentId = appointmentId
        prescription.note = self.getNote()
        prescription.date = currentDate
        prescription.instruction = ""
        prescription.medicines = listPrescription.filter({!$0.isTotalEmpty()})
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        PrescriptionAPI.submitPrescription(prescription) { (success, code, msg, params) in
            PKHUD.sharedHUD.hide(animated: true, completion: nil)
            if success {
                self.delegate.goBack()
            } else {
                Utils.showOKAlertPanel(self, title: "Lỗi", msg: "Kê toa không thành công! Xin vui lòng thử lại.")
            }
        }
    }
    
    func deletePrescription(sender: UIButton) {
        self.view.endEditing(true)
        
        listPrescription.removeAtIndex(sender.tag)
        tbPrescription.reloadData()
    }
    
    func showDataPicker(textField: UITextField){
        if vdataPicker == nil {
            vdataPicker = DataPicker(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height - 300, UIScreen.mainScreen().bounds.width, 300))
        }
        vdataPicker.setData(listPickerdata)
        vdataPicker.tf_current = textField
        textField.inputView = vdataPicker
    }
    
    func getNote()-> String {
        let file = "\(self.appointmentId)_note.txt"
        var text = ""
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)
            
            do {
                text = try NSString(contentsOfURL: path!, encoding: NSUTF8StringEncoding) as String
            }
            catch {/* error handling here */}
        }
        
        return text
    }
    
    func validateInput() -> Bool {
        var isValidate = true
        for prescription in listPrescription {
            if prescription.isEmpty() && !prescription.isTotalEmpty() {
                isValidate = false
                break
            }
        }
        
        return isValidate
    }
    
}

extension PrescriptionViewController: UITableViewDataSource, UITableViewDelegate {
    func configureTableView() {
        tbPrescription.registerNib(UINib(nibName: "PrescriptionCell", bundle: nil), forCellReuseIdentifier: "PrescriptionCell")
        tbPrescription.registerNib(UINib(nibName: "AddPrescriptionCell", bundle: nil), forCellReuseIdentifier: "AddPrescriptionCell")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return listPrescription.count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 150
        }
        return 30
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("PrescriptionCell", forIndexPath: indexPath) as! PrescriptionCell
            
            let prescription = listPrescription[indexPath.row]
            
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(PrescriptionViewController.deletePrescription(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            cell.tfName.tag = indexPath.row * PrescriptionCell.NTF + 0
            cell.tfName.delegate = self
            cell.tfQuantityTotal.tag = indexPath.row * PrescriptionCell.NTF + 1
            cell.tfQuantityTotal.delegate = self
            cell.tfquantityMorning.tag = indexPath.row * PrescriptionCell.NTF + 2
            cell.tfquantityMorning.delegate = self
            cell.tfquantityNoon.tag = indexPath.row * PrescriptionCell.NTF + 3
            cell.tfquantityNoon.delegate = self
            cell.tfquantityAfterNoon.tag = indexPath.row * PrescriptionCell.NTF + 4
            cell.tfquantityAfterNoon.delegate = self
            cell.tfquantityNight.tag = indexPath.row * PrescriptionCell.NTF + 5
            cell.tfquantityNight.delegate = self
            cell.tfInstr.tag = indexPath.row * PrescriptionCell.NTF + 6
            cell.tfInstr.delegate = self
            
            cell.tfQuantityTotal.text = prescription.quantityTotal != 0 ? "\(prescription.quantityTotal)" : ""
            cell.tfquantityAfterNoon.text = prescription.quantityAfternoon != 0 ? "\(prescription.quantityAfternoon)" : ""
            cell.tfquantityNoon.text = prescription.quantityNoon != 0 ? "\(prescription.quantityNoon)" : ""
            cell.tfquantityMorning.text = prescription.quantityMorning != 0 ? "\(prescription.quantityMorning)" : ""
            cell.tfquantityNight.text = prescription.quantityNight != 0 ? "\(prescription.quantityNight)" : ""
            cell.tfInstr.text = "\(prescription.instr)"
            cell.tfName.text = "\(prescription.name)"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("AddPrescriptionCell", forIndexPath: indexPath) as! AddPrescriptionCell
            
            cell.btnAdd.addTarget(self, action: #selector(addPrescription), forControlEvents: UIControlEvents.TouchUpInside)
            
            return cell
        }
    }
}

extension PrescriptionViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        let type = textField.tag % PrescriptionCell.NTF
        
        if [2, 3, 4, 5].contains(type) {
            listPickerdata = ["0", "0.5", "1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5"]
            showDataPicker(textField)
        } else if type == 6 {
            listPickerdata = ["", "Trước khi ăn", "Trước khi ngủ", "Ăn no trước khi uống"]
            showDataPicker(textField)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let row = textField.tag / PrescriptionCell.NTF
        let text = textField.text ?? ""
        if let medicine = listPrescription[safe: row] {
            switch textField.tag % PrescriptionCell.NTF {
            case 0:
                medicine.name = text
                break
            case 1:
                medicine.quantityTotal = Int(text) ?? 0
                break
            case 2:
                medicine.quantityMorning = Double(text) ?? 0
                break
            case 3:
                medicine.quantityNoon = Double(text) ?? 0
                break
            case 4:
                medicine.quantityAfternoon = Double(text) ?? 0
                break
            case 5:
                medicine.quantityNight = Double(text) ?? 0
                break
            case 6:
                medicine.instr = text
                break
            default:
                break
            }
        }
    }
}

extension PrescriptionViewController: DataPickerDelegate {
    func DataPickerDidSelectData(picker: DataPicker, data: String, didSelectRow row: Int) {
        if let tf = picker.tf_current {
            self.textFieldDidEndEditing(tf)
        }
    }
    
    func DataPickerDidDismiss() {
        
    }
}
