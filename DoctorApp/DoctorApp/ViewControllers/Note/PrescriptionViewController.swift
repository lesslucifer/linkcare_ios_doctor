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

        self.configureTableView()
        btnSubmit.linkcarelize()
    }

    func addPrescription(){
        updateData()
        let newPrescription = PrescriptionMedicine()
        listPrescription.append(newPrescription)
        
        tbPrescription.reloadData()
        
    }
    
    @IBAction func submit(sender: UIButton) {
        updateData()
        
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
        prescription.medicines = listPrescription
        
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
    
    
    func updateData() {
        let sum = listPrescription.count
        listPrescription = []
        for i in 0 ..< sum {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            
            let selectedCell = tbPrescription.cellForRowAtIndexPath(indexPath) as! PrescriptionCell
            let medicine = PrescriptionMedicine()
            medicine.name = selectedCell.tfName.text!
            medicine.quantityTotal = selectedCell.tfQuantityTotal.text != "" ? Int(selectedCell.tfQuantityTotal.text!)! : 0
            medicine.quantityMorning = selectedCell.tfquantityMorning.text != "" ? Double(selectedCell.tfquantityMorning.text!)! : 0
            medicine.quantityNoon = selectedCell.tfquantityNoon.text != "" ? Double(selectedCell.tfquantityNoon.text!)! : 0
            medicine.quantityAfternoon = selectedCell.tfquantityAfterNoon.text != "" ? Double(selectedCell.tfquantityAfterNoon.text!)! : 0
            medicine.quantityNight = selectedCell.tfquantityNight.text != "" ? Double(selectedCell.tfquantityNight.text!)! : 0
            medicine.instr = selectedCell.tfInstr.text!
            listPrescription.append(medicine)
        }
    }
    
    
    func deletePrescription(sender: UIButton) {
        updateData()
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
                text = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding) as String
            }
            catch {/* error handling here */}
        }
        
        return text
    }
    
    func validateInput() -> Bool {
        var isValidate = true
        for prescription in listPrescription {
            if prescription.quantityTotal == 0 {
                isValidate = false
                break
            }
            if prescription.name == "" {
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
            
            cell.tfquantityAfterNoon.delegate = self
            cell.tfquantityNoon.delegate = self
            cell.tfquantityMorning.delegate = self
            cell.tfquantityNight.delegate = self

            cell.tfInstr.tag = 1
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
        let type = textField.tag % 2
        
        if type == 0 {
            listPickerdata = ["0", "0.5", "1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5"]
            showDataPicker(textField)
        } else if type == 1 {
            listPickerdata = ["", "Trước khi ăn", "Trước khi ngủ", "Ăn no trước khi uống"]
            showDataPicker(textField)
        }
    }
}
