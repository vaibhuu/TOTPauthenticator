//
//  ViewController.swift
//  TotpAuthenticator
//
//  Created by Vaibhu Thakkar on 29/01/24.
//

import UIKit

class QrAndAuthenticatorViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var qrImageView: UIImageView!
    
    //MARK: - Variabes
    var secret = "UNEEN7ADGL7QWKQWM4G66KBHHHVBX5KPLGHK"
    var id = "26878"
    let org = "TOTPAuthenticator"
    
    //MARK: - App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let imgUrlStr = "https://www.google.com/chart?chs=250x250&chld=M|0&cht=qr&chl=otpauth://totp/\(org):\(id)?secret=\(secret)&issuer=\(org)"
        qrImageView.imageFromServerURL(imgUrlStr, placeHolder: nil)
    }
    
    //MARK: - IBActions
    @IBAction func btnGetTotp(_ sender: Any) {
        let tOtpStr = TotpAuthenticator.shared.getTOTP(secret: secret)
        if tOtpStr != "" {
            print(tOtpStr)
        } else {
            print("Secret key is invalid")
        }
        
    }
    
    
    @IBAction func btnAddToAuthenticatorApp(_ sender: Any) {
        let urlStr = "otpauth://totp/\(org):\(id)?secret=\(secret)&issuer=\(org)"
        UIApplication.shared.open(URL(string: urlStr)!)
    }
    
}

