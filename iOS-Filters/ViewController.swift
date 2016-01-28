//
//  ViewController.swift
//  iOS-Filters
//
//  Created by Deepak Kadarivel on 27/01/16.
//  Copyright © 2016 upbeatios. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    private var image: UIImage!
    
    @IBOutlet weak var filterPickerView: UIPickerView!
    
    let picker = UIImagePickerController()
    
    var imagePath = ""
    
    let context = CIContext(options: nil)
    
    let pickerData = ["SepiaEffect", "MonoEffect", "InstantEffect", "ChromeEffect", "FadeEffect", "MonochromeEffect", "NoirEffect", "ProcessEffect", "TonalEffect", "TransferEffect"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filterPickerView.dataSource = self
        filterPickerView.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "displayDialog")
        navigationItem.rightBarButtonItem = addButton
        self.navigationController?.navigationBar.topItem!.title = "Filter"
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerData[row] {
        case "SepiaEffect" : rangefilter("CISepiaTone", range: 0.5)
            break
        case "MonoEffect" : self.filter("CIPhotoEffectMono")
            break
        case "InstantEffect" : self.filter("CIPhotoEffectInstant")
            break
        case "ChromeEffect" : self.filter("CIPhotoEffectChrome")
            break
        case "FadeEffect" : self.filter("CIPhotoEffectFade")
            break
        case "MonochromeEffect" : rangefilter("CIColorMonochrome", range: 0.5)
            break
        case "NoirEffect" : self.filter("CIPhotoEffectNoir")
            break
        case "ProcessEffect" : self.filter("CIPhotoEffectProcess")
            break
        case "TonalEffect" : self.filter("CIPhotoEffectTonal")
            break
        case "TransferEffect" : self.filter("CIPhotoEffectTransfer")
            break
        default : break
        }
    }
    
    func filter(filter: String) {
        if image != nil {
            let beginImage = CIImage(image: image)
            let filteredImage = beginImage?.imageByApplyingFilter(filter, withInputParameters: nil)
            let renderedImage = context.createCGImage(filteredImage!, fromRect: (filteredImage?.extent)!)
            imageView.image = UIImage(CGImage: renderedImage)
        }
    }
    
    func rangefilter(filter: String, range: NSNumber) {
        if image != nil {
            let beginImage = CIImage(image: image)
            let sepiaColor = [kCIInputIntensityKey: (range)]
            let filteredImage = beginImage?.imageByApplyingFilter(filter, withInputParameters: sepiaColor)
            let renderedImage = context.createCGImage(filteredImage!, fromRect: (filteredImage?.extent)!)
            imageView.image = UIImage(CGImage: renderedImage)
        }
    }
    
    func sepiaEffect() {
        let beginImage = CIImage(image: image)
        
        let sepiaColor = [kCIInputIntensityKey: (0.5)]
        let filteredImage = beginImage?.imageByApplyingFilter("CISepiaTone", withInputParameters: sepiaColor)
        let renderedImage = context.createCGImage(filteredImage!, fromRect: (filteredImage?.extent)!)
        imageView.image = UIImage(CGImage: renderedImage)
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
        
        self.setThumb(tempImage)
        
    }
    
    func setThumb(tempImage: UIImage) {
        self.imageView.image = tempImage
        self.image = tempImage
    }
}

