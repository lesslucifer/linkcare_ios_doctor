//
//  PrescriptionViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 5/7/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

class ClinicalViewController: UIViewController {
    var appointmentId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func saveNote(string: String) {
        let file = "\(self.appointmentId)_note.txt"
        
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)
            
            //writing
            do {
                try string.writeToURL(path!, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch {/* error handling here */}
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ClinicalViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        saveNote(textView.text)
    }
}
