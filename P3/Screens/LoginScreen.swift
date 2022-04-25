import SwiftUI
import Firebase
import FirebaseFirestore




struct LoginScreen: View {
    
    //used for screen tabbing
    @State private var isLoginMode = false
    
    //used for credentials
    @State private var email = ""
    @State private var password = ""
    @State private var loginMessage = ""
    
    //used for profile picture
    @State private var ShowImageSelect = false
    @State private var image: UIImage?
    
    //login handler
//    @State private var log_in = false

    //checks if logged in
    let didLogin: () -> ()
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                
                VStack(spacing: 16) {
                    
                    //Selection tab
                    Picker(selection: $isLoginMode, label: Text("Picker")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
                    // end of selection tab
                    
                    // Displays Profile Picture Selection if not LoginMode
                    if !isLoginMode {
                        Button {
                            ShowImageSelect.toggle()
                        } label: {
                            
                            VStack {
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 140, height: 140)
                                        .cornerRadius(140)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size:64))
                                        .padding()
                                        .foregroundColor(Color(.gray))
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 140)
                                        .stroke(Color.gray, lineWidth: 2)
                            )
                        }
                    }
                    // End of Profile Pic
                    
                    // Email & PW Textfield
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.emailAddress)
                        .padding(12)
                        .background(Color.white)
                    
                    SecureField("Password", text: $password)
                        .padding(12)
                        .background(Color.white)
                    // end of email/pw textfield
                    
                    
                    
                    // Create/Login Button
                    Button {
                        handleAccount()
                        
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Login" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                            Spacer()
                        }
                        .background(Color.blue)
                        
                    }
                    

                    // end of login/create button
                    
                    
                    
                    //Login Message Display
                    Text(self.loginMessage)
                        .foregroundColor(.red)
                    //end of login message
                    
                    
                }.padding()
                
                
            }
            //title
            .navigationTitle(isLoginMode ? "Login" : "Create Account")
            .background(Color(.init(white:0, alpha: 0.05))
                            .ignoresSafeArea())
        }
        .navigationViewStyle(StackNavigationViewStyle())
//        .navigate(to: MessageView(), when: $log_in)
        
        // used for image selection
        .fullScreenCover(isPresented: $ShowImageSelect, onDismiss: nil) {
            //Text("test")
            ImageSelect(image: $image)
        }
    }
    
    /*
    Accout login/creation handler
     */
    private func handleAccount() {
        if isLoginMode {
            loginAcc()
            print("Log into Firebase w/ email \(email) & password \(password)")
        } else {
            createAcc()
            print("Register new Firebase account w/ email \(email) & password \(password) & image")
        }
        
    }
    
    
    /*
     Logs into Account
     */
    private func loginAcc() {
        firebaseManager.shared.auth.signIn(withEmail: email, password: password) {
            result, e in
            if let e = e {
                print("Failed to log into user:", e)
                self.loginMessage = "Failed: \(e)"
                return
            }
            
            print("logged into user: \(result?.user.uid ?? "" ) ")
            self.loginMessage = "logged into user: \(result?.user.uid ?? "" ) "
//            log_in.toggle()
            self.didLogin()
            
        }
    }
    
    /*
     Create Account Function
     */
    private func createAcc() {

        firebaseManager.shared.auth.createUser(withEmail: email, password: password) {
            result, e in
            if let e = e {
                print("Failed to create user:", e)
                self.loginMessage = "Failed: \(e)"
                return
            }
            
            print("created user: \(result?.user.uid ?? "" ) ")
            self.loginMessage = "created user: \(result?.user.uid ?? "" ) "
            self.ImageToStorage()
        }
    }
    
    
    //Moves selected image to firebase storage
    private func ImageToStorage() {
        print(1)
        guard let uid = firebaseManager.shared.auth.currentUser?.uid
            else { return }
        print(2)
        guard let imgData = self.image?.jpegData(compressionQuality: 0.69)
            else { return }
        print(3)
        let reference = firebaseManager.shared.storage.reference(withPath: uid)
        print(4)
        
        reference.putData(imgData, metadata: nil) { metadata, error in
            if let error = error {
                self.loginMessage = "Unable to save image to storage: \(error)"
                return
            }
            
            reference.downloadURL { url, error in
                if let error = error {
                    self.loginMessage = "Failed to download URL: \(error)"
                    return
                }
                self.loginMessage = "Stored image  url: \(url?.absoluteString ?? "") "
                print(url?.absoluteString)
                
                
                // guard variable needed to silence:
                // Value of optional type 'URL?' must be unwrapped to a value of type 'URL'
                guard let url = url else { return }
                self.storeUserInfo(imgURL: url)
            }
        }
    }
    
        private func storeUserInfo(imgURL: URL) {
            
            
            guard let uid = firebaseManager.shared.auth.currentUser?.uid else {
                return
            }
            
            let userData = ["email": self.email, "uid": uid, "imgURL": imgURL.absoluteString]
            
            firebaseManager.shared.firestore.collection("users")
                .document( uid ).setData(userData) { error in
                    if let error = error {
                        print(error)
                        self.loginMessage = "\(error)"
                        return
                    }
                    print("stored in firestore")
                    self.didLogin()
                }
        }
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen(didLogin: {})
            .preferredColorScheme(Variables.isDarkMode ? .dark : .light)
    }
}
