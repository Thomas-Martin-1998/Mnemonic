//
//  ViewController.swift
//  Mnemonic
//
//  Created by Thomas Martin on 26/07/2022.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    var password = "Error"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? PopupViewController
        vc?.passedData = password
        vc?.parentVC = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Image selected")
        self.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage{
            
            //Turn image into Data
            let imageData = image.pngData()!
            
            if imageData.count <= 2500
            {
                toast(message: "Image too small")
                return;
            }
            
            //Sample size
            let sampleData = imageData[1800..<2200]
            
            
            //Turn Data sample into Hexidecimal
            Thread{
                var hex = ""
                var uppercase = false
                let letters = NSCharacterSet.letters
                var containedLetters = true
                
                for number in sampleData{
                    
                    let temp = String(Int(number), radix: 16, uppercase: uppercase)
                    
                    //Alternate between upper and lower case
                    let range = temp.rangeOfCharacter(from: letters)
                    
                    if range != nil{
                        uppercase = !uppercase
                        containedLetters = true
                    }else{
                        containedLetters = false
                    }
                    
                    if containedLetters{
                        hex += temp
                    }
                }
                
                //Remove all 0's
                var code = hex.replacingOccurrences(of: "0", with: "")
                
                //Set code start and end locations
                let start = String.Index(utf16Offset: 20, in: code)
                let end = String.Index(utf16Offset: 37, in: code)
                
                //Shorten code
                code = String(code[start..<end])
                
                //Turn code into array
                var array = Array(code)
                
                //Replace 5th and 11th char with -
                array[5] = "-"
                array[11] = "-"
                
                //Convert back into string
                code = String(array)
                
                //Display code to user
                DispatchQueue.main.async(){
                    self.password = code
                    self.performSegue(withIdentifier: "SG1", sender: self)
                    
                }
                
            }.start()
        }
        else{
            return
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Selection cancelled")
        self.dismiss(animated: true)
    }
    
    @IBAction func selectBtnPress(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Opening Gallery")
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func toast(message: String){
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 90, y: 50, width: 180, height: 35))
        
        toastLabel.backgroundColor = UIColor.white
        toastLabel.textColor = UIColor.black
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: 18)
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        self.view.addSubview(toastLabel)
        
        //display toast
        UIView.animate(withDuration: 3.0, delay: 0.1, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
}

