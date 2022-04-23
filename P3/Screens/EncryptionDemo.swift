//
//  EncryptionDemo.swift
//  P3
//
//  Created by Silas White on 4/20/22.
//

import SwiftUI
import CryptoKit

struct EncryptionDemo: View {
    @State var privateKey1: Curve25519.KeyAgreement.PrivateKey?
    @State var privateKey2: Curve25519.KeyAgreement.PrivateKey?
    @State var symmetricKey: SymmetricKey?
    @State var displayedText: String
    @State var showKey1: Bool
    @State var showKey2: Bool
    @State var encrypted: Bool
    
    var body: some View {
        VStack {
            Button {
                privateKey1 = generatePrivateKey()
                print(privateKey1?.publicKey as Any)
                showKey1 = true;
            } label: {
                Text("Generate new key")
            }
            .padding()
            if (showKey1) {
                VStack {
                    Text("User 1's Private Key")
                    Text(exportPrivateKey(privateKey1!))
                }
                .padding()
            }
            Button {
                privateKey2 = generatePrivateKey()
                print(privateKey1?.publicKey as Any)
                showKey2 = true;
            } label: {
                Text("Generate new key")
            }
            .padding()
            if (showKey2) {
                VStack {
                    Text("User 2's Private Key")
                    Text(exportPrivateKey(privateKey2!))
                }
                .padding()
            }
            Button {
                do {
                    symmetricKey = try deriveSymmetricKey(privateKey: (privateKey1)!, publicKey: privateKey2!.publicKey, salt: "bruh")
                } catch {
                    print("Symmetric key failure")
                }
                print(symmetricKey as Any)
            } label: {
                Text("Generate Symmetric Key")
            }
            .padding()
            Button {
                if (encrypted) {
                    displayedText = decrypt(text: displayedText, symmetricKey: symmetricKey!)
                    encrypted = false
                } else {
                    do {
                        displayedText = try encrypt(text: displayedText, symmetricKey: symmetricKey!)
                    } catch {
                        print("encrypt error")
                    }
                    encrypted = true
                }
                
            } label: {
                Text("Encrypt/Decrypt")
            }
            .padding()
            
            
            Text(displayedText)
        }
    }
}

struct EncryptionDemo_Previews: PreviewProvider {
    static var previews: some View {
        EncryptionDemo(displayedText: "Example", showKey1: false, showKey2: false, encrypted: false)
    }
}
