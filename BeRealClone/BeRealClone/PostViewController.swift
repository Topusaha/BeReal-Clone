//
//  PostViewController.swift
//  BeRealClone
//
//  Created by Topu Saha on 3/8/24.
//

import UIKit
import PhotosUI
import ParseSwift
import AlamofireImage


class PostViewController: UIViewController {
    
    @IBOutlet weak var captain: UITextField!
    @IBOutlet weak var uploadedImage: UIImageView!
    
    private var pickedImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onTappedButton(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("❌📷 Camera not available")
            return
        }

        // Instantiate the image picker
        let imagePicker = UIImagePickerController()

        // Shows the camera (vs the photo library)
        imagePicker.sourceType = .camera

        // Allows user to edit image within image picker flow (i.e. crop, etc.)
        // If you don't want to allow editing, you can leave out this line as the default value of `allowsEditing` is false
        imagePicker.allowsEditing = true

        // The image picker (camera in this case) will return captured photos via it's delegate method to it's assigned delegate.
        // Delegate assignee must conform and implement both `UIImagePickerControllerDelegate` and `UINavigationControllerDelegate`
        imagePicker.delegate = self

        // Present the image picker (camera)
        present(imagePicker, animated: true)

    }
    
    
    
    
    
    private func presentGoToSettingsAlert() {
        _ = UIAlertController (
            title: "Photo Access Required",
            message: "In order to post a photo to complete a task, we need access to your photo library. You can allow access in Settings",
            preferredStyle: .alert)
        
        _ = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
    }
    
    
    private func showAlert(description: String) {
            let alertController = UIAlertController(title: "Error", message: description, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    
    @IBAction func addNewPost(_ sender: Any) {
        
        if var currentUser = User.current {

            // Update the `lastPostedDate` property on the user with the current date.
            currentUser.lastPostedDate = Date()

            // Save updates to the user (async)
            currentUser.save { [weak self] result in
                switch result {
                case .success(let user):
                    print("✅ User Saved! \(user)")

                    // Switch to the main thread for any UI updates
                    DispatchQueue.main.async {
                        // Return to previous view controller
                        self?.navigationController?.popViewController(animated: true)
                    }

                case .failure(let error):
                    self?.showAlert(description: error.localizedDescription)
                }
            }
        }
        
        guard let image = uploadedImage.image,
              let imageData = image.jpegData(compressionQuality: 0.1) else {
        return
        }

        let imageFile = ParseFile(name: "image.jpg", data: imageData)

        var post = Post()

        post.imageFile = imageFile
        post.captain = captain.text
        post.user = User.current

        post.save { [weak self] result in

            DispatchQueue.main.async {
                switch result {
                case .success(let post):
                    print("✅ Post Saved! \(post)")

                    self?.dismiss(animated: true, completion: nil)

                case .failure(let error):
                    self?.showAlert(description: error.localizedDescription)
                }
            }
        }
    }
}

extension PostViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
               print("❌📷 Unable to get image")
               return
           }

        uploadedImage.image = image
        pickedImage = image
    }
    
}
