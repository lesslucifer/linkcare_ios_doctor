//
//  PrescriptionViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 5/7/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

class PrescriptionViewController: UIViewController {
    var appointmentId: Int!
    
    @IBOutlet var tbPrescription: UITableView!
    @IBOutlet var btnEdit: UIBarButtonItem!
    
    var listPrescription = [PrescriptionMedicine()]
    private var vdataPicker: DataPicker!
    private var listPickerdata: Array<String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureTableView()
        
    }

    func addPrescription(){
        updateData()
        var newPrescription = PrescriptionMedicine()
//        let indexPath = NSIndexPath(forRow: listPrescription.count, inSection: 0)
        listPrescription.append(newPrescription)
        
        tbPrescription.reloadData()
        
    }
    @IBAction func submit(sender: UIButton) {
        updateData()
        
        let currentDate = NSDate()
        
        var prescription = Prescription()
        prescription.appointmentId = appointmentId
        prescription.note = self.getNote()
        prescription.date = currentDate
        prescription.instruction = ""
//        prescription.medicines = [listPrescription].map({ ($0.copy() as! PrescriptionMedicine) })
        prescription.medicines = listPrescription
        
        PrescriptionAPI.submitPrescription(prescription) { (success, code, msg, params) in
            print(msg)
        }

        
    }
    
    
    func updateData() {
        let sum = listPrescription.count
        listPrescription = []
        for (var i = 0; i < sum; i += 1){
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            
            let selectedCell = tbPrescription.cellForRowAtIndexPath(indexPath) as? PrescriptionCell
            let medicine = PrescriptionMedicine()
            medicine.name = selectedCell!.tfName.text!
            medicine.quantityTotal = Int(selectedCell!.tfQuantityTotal.text!)!
            medicine.quantityMorning = Double(selectedCell!.tfquantityMorning.text!)!
            medicine.quantityNoon = Double(selectedCell!.tfquantityNoon.text!)!
            medicine.quantityAfternoon = Double(selectedCell!.tfquantityAfterNoon.text!)!
            medicine.quantityNight = Double(selectedCell!.tfquantityNight.text!)!
            medicine.instr = selectedCell!.tfName.text!
            listPrescription.append(medicine)
        }
    }
    
    
    func deletePrescription(sender: UIButton) {
        listPrescription.removeAtIndex(sender.tag)
        print(sender.tag)
        
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        tbPrescription.beginUpdates()
        tbPrescription.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        tbPrescription.endUpdates()
        
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
            
            cell.tfQuantityTotal.text = "\(prescription.quantityTotal)"
            cell.tfquantityAfterNoon.text = "\(prescription.quantityAfternoon)"
            cell.tfquantityNoon.text = "\(prescription.quantityNoon)"
            cell.tfquantityMorning.text = "\(prescription.quantityMorning)"
            cell.tfquantityNight.text = "\(prescription.quantityNight)"
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
            listPickerdata = ["0.5", "1.0", "1.5", "2.0"]
            showDataPicker(textField)
        } else if type == 1 {
            listPickerdata = ["Trước khi ăn", "Trước khi ngủ", "Ăn no trước khi uống"]
            showDataPicker(textField)
        }
    }
}
