//
//  RegisterViewController.swift
//  O-Joker
//
//  Created by admin on 23.02.2023.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import Firebase
import FirebaseStorage

class RegisterViewController: UIViewController {

   
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBAction func registerTap(_ sender: UIButton) {
        guard let password = passwordTextField.text, let repeatedPassword = repeatPasswordTextField.text,
              let username = usernameTextField.text, let email = emailTextField.text,
              !password.isEmpty, password == repeatedPassword, !email.isEmpty, !username.isEmpty else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                print("Error creating user")
                return
            }
            guard let uid = authResult?.user.uid else {
                           return
                       }
            var user = ["username": username, "email" : email]
            guard let imageData = self.profileImageView.image?.jpegData(compressionQuality: 0.4) else {
                return
            }
            let storageRef = Storage.storage().reference(forURL: "gs://o-joker.appspot.com/")
            let storageProfileRef = storageRef.child("profile").child("\(uid)")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            
            storageProfileRef.putData(imageData, metadata: metadata, completion: {
                (storageMetaDate, error) in
                guard error == nil else {
                    print("image load error")
                    return
                }
                storageProfileRef.downloadURL(completion: {
                    (url, error) in
                    guard let metaImageURL = url?.absoluteString else {
                        print("image url load error")
                        return
                    }
                    print(metaImageURL)
                    user["profileImageURL"] = metaImageURL
                    self.ref.child("users").child(uid).setValue(user)
                })
            })
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print("Error signing in: \(error.localizedDescription)")
                        return
                    }
                    
                    // User signed in successfully
                    print("User signed in with UID: \(result!.user.uid)")
                self.performSegue(withIdentifier: "register", sender: self.registerButton)
                }
            
        }
    }
    
    var ref = DatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardRecognizer()
        view.backgroundColor = UIColor(cgColor: CGColor(red: 25/255, green: 26/255, blue: 30/255, alpha: 1))
        self.ref = Database.database().reference()
        setupProfileImage()
    }
    
    func setupProfileImage(){
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeImage)))
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
    }
    
    @objc func changeImage(){
        presentPhotoActionSheet()
    }
    
    func hideKeyboardRecognizer(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(view.endEditing)))
    }
    
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Photo", message: "How you want to select  a photo?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: {[weak self]_ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.presentPhotoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title : "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    
    func presentPhotoLibrary(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] else {
            return
        }
        self.profileImageView.image = selectedImage as? UIImage
    }
     
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
