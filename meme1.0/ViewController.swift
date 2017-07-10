//
//  ViewController.swift
//  meme1.0
//
//  Created by Rishav on 20/03/17.
//  Copyright © 2017 Rishav. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var navigator: UINavigationBar!
    @IBOutlet weak var tool: UIToolbar!
    @IBOutlet weak var album: UIBarButtonItem!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    let memeTextAtt = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName :UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
        ] as [String : Any]
    
    let shareBar: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem:.action, target: self, action: #selector(ViewController.userTapShare))
    
    let cancelBar: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem:.cancel, target: self, action: #selector(ViewController.cancel))
    
    
    var bottomheight : CGFloat!
    
    func configure(_ textField: UITextField) {
        topText.defaultTextAttributes = memeTextAtt
        bottomText.defaultTextAttributes = memeTextAtt
        topText.textAlignment = NSTextAlignment.center
        bottomText.textAlignment = NSTextAlignment.center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(topText)
        configure(bottomText)
        self.navigator.topItem?.rightBarButtonItem = cancelBar
        self.navigator.topItem?.leftBarButtonItem = shareBar
        shareBar.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        topText.delegate = self
        bottomText.delegate = self
    }

   
    
    func userTapShare() {
        let meme = generateMemeImage()
        let objectToShare = [meme]
        let activityVC = UIActivityViewController(activityItems: objectToShare,
                                                  applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {
            (activityType, completed, returnedItems, activityError) in
            if completed {
                self.save()
            }
        }
        
        activityVC.popoverPresentationController?.barButtonItem = shareBar
        present(activityVC, animated: true, completion: nil)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y = bottomheight - getKeyboardHeight(notification: notification)
    }
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = bottomheight
        self.unsubscribeFromKeyboardNotifications()
    }
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        subscribeToKeyboardNotifications()
    }
    override func viewDidAppear(_ animated: Bool) {
        bottomheight = self.view.frame.origin.y
        unsubscribeFromKeyboardNotifications()
    }
    
    
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    
    func cancel() {
        imageView.image = nil
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        shareBar.isEnabled = false
    }
    func pickAnImageFrom(_ source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if (source == UIImagePickerControllerSourceType.camera) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        self.present(imagePicker, animated: true, completion: nil)
        }
        if (source == UIImagePickerControllerSourceType.photoLibrary) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func pickImageFromCamera (sender: AnyObject) {
        pickAnImageFrom(UIImagePickerControllerSourceType.camera)
    }

    @IBAction func pickImageFromAlbum (sender: AnyObject) {
        pickAnImageFrom(UIImagePickerControllerSourceType.photoLibrary)
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == bottomText) {
            self.subscribeToKeyboardNotifications()
        }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    
   func imagePickerController( _ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.layer.masksToBounds = true
            imageView.image = image
            shareBar.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel( _ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func save() {
    _ = Meme1(topText: topText.text!,bottomText: bottomText.text!, image:imageView.image, memedImage:generateMemeImage())
    }
    
    func generateMemeImage() -> UIImage {
        navigator.isHidden = true
        tool.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame,
                           afterScreenUpdates: true)
        let memeImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigator.isHidden = false
        tool.isHidden = false
        return memeImage
    }
}

