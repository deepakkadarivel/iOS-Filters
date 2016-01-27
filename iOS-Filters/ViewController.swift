//
//  ViewController.swift
//  iOS-Filters
//
//  Created by Deepak Kadarivel on 27/01/16.
//  Copyright © 2016 upbeatios. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    private var image: UIImage!
    
    let picker = UIImagePickerController()
    
    var imagePath = ""
    
    let context = CIContext(options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "displayDialog")
        navigationItem.rightBarButtonItem = addButton
        self.navigationController?.navigationBar.topItem!.title = "Filter"
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
    }

    @IBAction func applyFilter(sender: AnyObject) {
        if image != nil {
            let inputImage = CIImage(image: image)
            
            let randomColor = [kCIInputAngleKey: (Double (arc4random_uniform(314))/100)]
            print("\(randomColor)")
            
            let filteredImage = inputImage?.imageByApplyingFilter("CIHueAdjust", withInputParameters: randomColor)
            
            let renderedImage = context.createCGImage(filteredImage!, fromRect: (filteredImage?.extent)!)
            
            imageView.image = UIImage(CGImage: renderedImage)
        }
    }

    func displayDialog() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        
        let OKAction = UIAlertAction(title: "Choose from Gallery", style: .Default) { (action) in
            self.openGallery()
        }
        alertController.addAction(OKAction)
        
        let destroyAction = UIAlertAction(title: "Take a Photo", style: .Default) { (action) in
            self.openCamera()
        }
        alertController.addAction(destroyAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func openGallery() {
        self.imageView.image = nil
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            picker.allowsEditing = false
            
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    func openCamera() {
        picker.delegate = self
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.allowsEditing = true
            self .presentViewController(picker, animated: true, completion: nil)
        }
        else
        {
            let alertController = UIAlertController(title: "No Camera", message: "Simulator has no Camera", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
            }
            
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let tempImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // save your image here into Document Directory
        self.imageView.image = tempImage
        self.image = tempImage
    }
}

