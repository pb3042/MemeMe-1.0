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
        
        self.subscribeToKeyboardNotifications()
        
        memeImageView.contentMode = .scaleAspectFit
        }

    @IBOutlet weak var memeImageView: UIImageView!
   
    @IBOutlet weak var albumPicker: UIBarButtonItem!

    @IBOutlet weak var cameraPicker: UIBarButtonItem!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var bottomTextBox: UITextField! {
        didSet {
            bottomTextBox.text = bottomTextDefaultValue
            bottomTextBox.defaultTextAttributes = memeTextAttributes
            bottomTextBox.delegate = self
            bottomTextBox.textAlignment = NSTextAlignment.center
        }
    }
    
    @IBOutlet weak var topTextBox: UITextField!{
        didSet {
            topTextBox.text = topTextDefaultValue
            topTextBox.defaultTextAttributes = memeTextAttributes
            topTextBox.delegate = self
            topTextBox.textAlignment = NSTextAlignment.center
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
    
    func initialize(textField:UITextField) {
        textField.isHidden = false
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        
        initialize(textField: topTextBox)
        initialize(textField: bottomTextBox)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func generateMemedImage() -> UIImage {
        
        navigationBar.isHidden = true
        bottomToolBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame,afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationBar.isHidden = false
        bottomToolBar.isHidden = false
        
        return memedImage
        }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.frame.origin.y = 0
        if textField == topTextBox && topTextBox.text == "" {
            topTextBox.text = "TOP"
        }
        
        else if textField == bottomTextBox && bottomTextBox.text == "" {
            bottomTextBox.text = "BOTTOM"
        }
    }
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage],applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activity,completed, items, error) in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        self.present(activityViewController, animated: true, completion: nil)
        }
    
    @IBAction func cameraPicker(_ sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        imagePicker.isEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        memeImageView.image = nil
        topTextBox.text = topTextDefaultValue
        bottomTextBox.text = bottomTextDefaultValue
        dismiss(animated: true, completion: nil)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraPicker.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        subscribeToKeyboardNotifications()
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        }
    
    func keyboardWillShow(_ notification:Notification) {
        if bottomTextBox.isFirstResponder {
        self.view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if bottomTextBox.isFirstResponder {
        self.view.frame.origin.y = +getKeyboardHeight(notification)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    func getKeyboardHeight(_ notificaion: Notification) -> CGFloat {
        let userInfo = notificaion.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }

    struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage!
    var memedImage: UIImage!
    }

    func save() {
    _ = Meme(topText: topTextBox.text!, bottomText: bottomTextBox.text!, originalImage: memeImageView.image!, memedImage: memedImage)
        }
    }

    var topTextBox : String!
    var bottomTextBox : String!
    var originalImage : UIImage!
    var memedImage: UIImage!


    let topTextDefaultValue = "TOP"
    let bottomTextDefaultValue = "BOTTOM"





