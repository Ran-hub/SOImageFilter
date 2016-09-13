//
//  ViewController.swift
//  SOImagePickerController
//
//  Created by myCompany on 9/6/16.
//  Copyright © 2016 myCompany. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgView: UIImageView!
    
    var context: CIContext = CIContext(options: nil)
    var appliedFilter: CIFilter!
    
    var origionalImage : UIImage!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    //Action for capture image from Camera
    @IBAction func actionClickOnCamera(sender: AnyObject) {

        //This condition is used for check availability of camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true;
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.delegate = self
            presentViewController(imagePicker, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Alert", message: "You don't have a camera for this device", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //Action for fetch image from Gallery
    @IBAction func actionClickOnGallery(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true;
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        origionalImage = info[UIImagePickerControllerEditedImage] as? UIImage
        imgView.image = origionalImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//        imgView.image = image
//        dismissViewControllerAnimated(true, completion: nil)
//    }
    
    
    //Open popup for filters type
    @IBAction func actionFilter(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "CIVignette", style: .Default, handler: handleFilterSelection))
        actionSheet.addAction(UIAlertAction(title: "CIVignetteEffect", style: .Default, handler: handleFilterSelection))
        actionSheet.addAction(UIAlertAction(title: "CIFalseColor", style: .Default, handler: handleFilterSelection))
        actionSheet.addAction(UIAlertAction(title: "CISepiaTone", style: .Default, handler: handleFilterSelection))
        actionSheet.addAction(UIAlertAction(title: "CIPhotoEffectProcess", style: .Default, handler: handleFilterSelection))
        actionSheet.addAction(UIAlertAction(title: "CICircularScreen", style: .Default, handler: handleFilterSelection))
        actionSheet.addAction(UIAlertAction(title: "CIHatchedScreen", style: .Default, handler: handleFilterSelection))
        actionSheet.addAction(UIAlertAction(title: "CIHoleDistortion", style: .Default, handler: handleFilterSelection))
        actionSheet.addAction(UIAlertAction(title: "CIVortexDistortion", style: .Default, handler: handleFilterSelection))
        actionSheet.addAction(UIAlertAction(title: "CIPixellate", style: .Default, handler: handleFilterSelection))
        actionSheet.addAction(UIAlertAction(title: "CITwirlDistortion", style: .Default, handler: handleFilterSelection))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func handleFilterSelection(action: UIAlertAction!) {
        appliedFilter = CIFilter(name: action.title!)
        
        let beginImage = CIImage(image: imgView.image!)
        appliedFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyFilter()
    }
    
    func applyFilter() {
        let inputKeys = appliedFilter.inputKeys
        let intensity = 0.5
        
        if inputKeys.contains(kCIInputIntensityKey) { appliedFilter.setValue(intensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { appliedFilter.setValue(intensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { appliedFilter.setValue(intensity * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { appliedFilter.setValue(CIVector(x: imgView.image!.size.width / 2, y: imgView.image!.size.height / 2), forKey: kCIInputCenterKey) }
        
        let cgImage = context.createCGImage(appliedFilter.outputImage!, fromRect: appliedFilter.outputImage!.extent)
        let filteredImage = UIImage(CGImage: cgImage)
        
        self.imgView.image = filteredImage
    }

    //Refresh image and load origional
    @IBAction func actionRefreshImage(sender: AnyObject) {
        imgView.image = origionalImage
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

