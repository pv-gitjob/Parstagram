//
//  ProfileViewController.swift
//  Parstagram
//
//  Created by Praveen V on 2/20/20.
//  Copyright © 2020 Praveen Vandeyar. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = PFUser.current()!
        if user["profilePicture"] != nil {
            let imageFileP = user["profilePicture"] as! PFFileObject
            let urlStringP = imageFileP.url!
            let urlP = URL(string: urlStringP)!
            profileImageView.af_setImage(withURL: urlP)
        }
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        let user = PFUser.current()!
        let imageData = profileImageView.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        user["profilePicture"] = file
        
        user.saveInBackground {(success ,error) in
            if success{
                self.dismiss(animated: true, completion: nil)
                print("Saved")
            }else {
                print("error!")
            }
        }

    }
    
    @IBAction func uploadImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        }else{
            picker.sourceType = .photoLibrary
        }
        
        present(picker,animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        profileImageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
