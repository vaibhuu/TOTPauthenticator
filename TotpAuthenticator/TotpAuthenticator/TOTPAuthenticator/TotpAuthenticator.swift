//
//  TotpAuthenticatorExtension.swift
//  qrAuthenticator
//
//  Created by Vaibhu Thakkar on 29/01/24.
//

import Foundation
import CryptoKit

class TotpAuthenticator {
    
    //MARK: - Shared Constant
    static let shared = TotpAuthenticator()
    
    //MARK: - Constant
    let period = TimeInterval(30)
    let digits = 6
    
    //MARK: - Generate Totp to authenticate with authenticator app (Google, Microsoft Authenticator)
    func getTOTP(secret: String) -> String {
        guard let decodedSecret = base32Decode(secret) else { return "" }
        let secret = Data(decodedSecret)
        var counter = UInt64(Date().timeIntervalSince1970 / period).bigEndian

        let counterData = withUnsafeBytes(of: &counter) { Array($0) }
        let hash = HMAC<Insecure.SHA1>.authenticationCode(for: counterData, using: SymmetricKey(data: secret))
     
        var truncatedHash = hash.withUnsafeBytes { ptr -> UInt32 in
            let offset = ptr[hash.byteCount - 1] & 0x0f
     
            let truncatedHashPtr = ptr.baseAddress! + Int(offset)
            return truncatedHashPtr.bindMemory(to: UInt32.self, capacity: 1).pointee
        }
     
        truncatedHash = UInt32(bigEndian: truncatedHash)
        truncatedHash = truncatedHash & 0x7FFF_FFFF
        truncatedHash = truncatedHash % UInt32(pow(10, Float(digits)))
     
        return (String(format: "%0*u", digits, truncatedHash))
    }
}
