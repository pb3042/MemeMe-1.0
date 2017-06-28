//
//  ViewController.swift
//  MemeMe
//
//  Created by Paul Brann on 6/15/17.
//  Copyright © 2017 Paul Brann. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    let memeTextAttributes = [
        NSStrokeWidthAttributeName: -3.0,
        NSForegroundColorAttributeName: UIColor.white,
        NSStrokeColorAttributeName: UIColor.black,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!] as [String : Any]
        
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextBox.isHidden = false
        topTextBox.defaultTextAttributes = memeTextAttributes
        topTextBox.textAlignment = NSTextAlignment.center
        topTextBox.delegate = self
        bottomTextBox.isHidden = false
        bottomTextBox.defaultTextAttributes = memeTextAttributes
        bottomTextBox.textAlignment = NSTextAlignment.center
        bottomTextBox.delegate = self
        
    }

    @IBOutlet weak var memeImageView: UIImageView!
   
    @IBOutlet weak var albumPicker: UIBarButtonItem!

    @IBOutlet weak var cameraPicker: UIBarButtonItem!
    
    @IBOutlet weak var bottomTextBox: UITextField!{
        didSet {
            bottomTextBox.text = bottomTextDefaultValue
            bottomTextBox.defaultTextAttributes = memeTextAttributes
            bottomTextBox.delegate = self
        }
    }
    
    @IBOutlet weak var topTextBox: UITextField!{
        didSet {
            topTextBox.text = topTextDefaultValue
            topTextBox.defaultTextAttributes = memeTextAttributes
            topTextBox.delegate = self
        }
    }
    
    @IBAction func albumPicker(_ sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.isEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.image = image
            dismiss(animated: true, completion: nil)
            
        }
    
        
    }

    @IBAction func cameraPicker(_ sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        imagePicker.isEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraPicker.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        
    }
    var memedImage : UIImage!
    let topTextDefaultValue = "TOP"
    let bottomTextDefaultValue = "BOTTOM"
}






