
//  ViewController.swift
//  TestPhotoProject
//
//  Created by Chanchal on 10/07/17.
//  Copyright © 2017 Naxtre. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    
    //MARK: - Variables and array
    
    var pictureTimer = Timer()
    let imagePicker = UIImagePickerController()
    var pictruesArray = NSMutableArray()
    var savedPicsArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - OpenCamera
    
    @IBAction func BtnClicked_openCamera(_ sender: Any)
    {
         if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  AVAuthorizationStatus.authorized{
            self.openCamera()
        }
        else
        {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted :Bool) -> Void in
                if granted == true
                {
                    // User granted
                    print("User granted")
                    DispatchQueue.main.async {
                        self.openCamera()
                    }
                }
                else
                {
                    self.showSettings()
                }
            })
        }
    }
    
    //MARK: - showCameraSettings
    func showSettings()
    {
        let cameraUnavailableAlertController = UIAlertController (title: "Camera Unavailable", message: "Please check to see if it is disconnected or in use by another application", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .destructive) { (_) -> Void in
            let settingsUrl = NSURL(string:UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                DispatchQueue.main.async {
                    UIApplication.shared.openURL(url as URL)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        cameraUnavailableAlertController .addAction(settingsAction)
        cameraUnavailableAlertController .addAction(cancelAction)
        let app = UIApplication.shared.delegate as? AppDelegate
        let window = app?.window
        window?.rootViewController!.present(cameraUnavailableAlertController , animated: true, completion: nil)
    }
    
    //MARK: - OpenCamera
    func openCamera()
    {
        pictureTimer.invalidate()
        pictruesArray.removeAllObjects()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        imagePicker.allowsEditing = false
        imagePicker.cameraDevice = UIImagePickerController.isCameraDeviceAvailable(.front) ? .front : .rear
        imagePicker.showsCameraControls = false
        pictureTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(takePictures), userInfo: nil, repeats: true)
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - takePicturesFromCamera
    func takePictures()
    {
        if pictruesArray.count == 10
        {
            let arrayAsPLISTData = NSKeyedArchiver.archivedData(withRootObject: pictruesArray)
            SaveFetchPicturesData().save(pics: arrayAsPLISTData)
            imagePicker.dismiss(animated: true, completion: nil)
            pictureTimer.invalidate()
        }
        else
        {
            imagePicker.takePicture()
        }
    }
    
    
    //MARK: - imagePickerControllerDeleagte
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let data =    UIImageJPEGRepresentation(pickedImage, 0.7)
            pictruesArray.add(data)
        }
    }
    
    //MARK: - fetchImages from database
    func fetchImages()
    {
        let data =    SaveFetchPicturesData().fetchData().mutableCopy() as! NSMutableArray
        let picData : NSArray = (data.value(forKey: "Pictures") as? NSArray)!
        savedPicsArray.removeAllObjects()
        for index in 0..<picData.count
        {
            let arrayOfImages : NSArray = NSKeyedUnarchiver.unarchiveObject(with: picData.object(at: index) as! Data) as! NSArray
            savedPicsArray.add(arrayOfImages)
            //       var data_image : UIImage =  UIImage(data: arrayOfImages.object(at: 0) as! Data)!
            //       print(data_image)
        }
    }
}

