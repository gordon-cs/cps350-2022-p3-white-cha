//
//  Encryption.swift
//  P3
//
//  Created by Silas White on 4/7/22.
//

import CryptoKit
import Foundation

/// Generate a private key according to the Curve25519 encryption public/private key protocol
///
/// - Returns: the private key in its PrivateKey() struct format
///
func generatePrivateKey() -> Curve25519.KeyAgreement.PrivateKey {
    return Curve25519.KeyAgreement.PrivateKey()
}

/// Converts a encryption key to a string so it can be stored locally
///
/// - Parameters:
///     - privateKey: the Curve25519 private key to be converted
/// - Returns: the string representation of the private key
/// 
func exportPrivateKey(_ privateKey: Curve25519.KeyAgreement.PrivateKey) -> String {
    let rawPrivateKey = privateKey.rawRepresentation
    let privateKeyBase64 = rawPrivateKey.base64EncodedString()
    let percentEncodedPrivateKey = privateKeyBase64.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
    return percentEncodedPrivateKey
}

/// Converts a string to its private encryption key
///
/// - Parameters:
///     - privateKey: the string which holds the private key to be converted
/// - Returns: the Curve25519 representation of the private key
///
func importPrivateKey(_ privateKey: String) throws -> Curve25519.KeyAgreement.PrivateKey {
    let privateKeyBase64 = privateKey.removingPercentEncoding!
    let rawPrivateKey = Data(base64Encoded: privateKeyBase64)!
    return try Curve25519.KeyAgreement.PrivateKey(rawRepresentation: rawPrivateKey)
}

/// Created a symmetric key given this users private key and the other users public key (Diffie-Hellman exchange)
///
/// - Parameters:
///     - privateKey: the Curve25519 private key of the current user
///     - publicKey: the Curve25519 public key of the other user
///     - salt: the string to be user to salt the symmetric key (likely UID)
///
/// - Returns: the symmetric key to encrypt data between the two users
///
func deriveSymmetricKey(privateKey: Curve25519.KeyAgreement.PrivateKey, publicKey: Curve25519.KeyAgreement.PublicKey, salt: String) throws -> SymmetricKey {
    let sharedSecret = try privateKey.sharedSecretFromKeyAgreement(with: publicKey)
    
    let symmetricKey = sharedSecret.hkdfDerivedSymmetricKey(
        using: SHA256.self,
        salt: salt.data(using: .utf8)!,
        sharedInfo: Data(),
        outputByteCount: 32
    )
    
    return symmetricKey
}

/// Encrypts a plain text message into an encrypted message
///
/// - Parameters:
///     - text: the text to be encrypted
///     - symmetricKey: the symmetric key to encrypt the message with
///
/// - Returns: the encrypted string
///
func encrypt(text: String, symmetricKey: SymmetricKey) throws -> String {
    let textData = text.data(using: .utf8)!
    let encrypted = try AES.GCM.seal(textData, using: symmetricKey)
    return encrypted.combined!.base64EncodedString()
}

/// Decrypt an encrypted message into a decrypted message
///
/// - Parameters:
///     - text: the encrypted string to decrypt
///     - symmetricKey: the symmetric key to decrypt the message with
///
/// - Returns: the decrypted string
///
func decrypt(text: String, symmetricKey: SymmetricKey) -> String {
    do {
        guard let data = Data(base64Encoded: text) else {
            return "Could not decode text: \(text)"
        }
        
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        let decryptedData = try AES.GCM.open(sealedBox, using: symmetricKey)
        
        guard let text = String(data: decryptedData, encoding: .utf8) else {
            return "Could not decode data: \(decryptedData)"
        }
        
        return text
    } catch let error {
        return "Error decrypting message: \(error.localizedDescription)"
    }
}

