import SwiftUI
import Firebase


/*
 Singleton FirebaseApp to prevent reconfigure crash
 */
class firebaseManager: NSObject {
    let auth: Auth
    //singleton
    static let shared = firebaseManager()
    
    override init () {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        super.init()
    }
    
}

struct LoginScreen: View {
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    @State var dpPath = ""
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                
                VStack(spacing: 16) {
                    
                    
                    //Selection tab
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
                    
                    // Displays Profile Picture Selection if not LoginMode
                    if !isLoginMode {
                        Button {
                            
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size:64))
                                .padding()
                        }
                    }
                    
                    // Email & PW Textfield
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(12)
                        .background(Color.white)
                    
                    SecureField("Password", text: $password)
                        .padding(12)
                        .background(Color.white)
                    
                    
                    // Create Button
                    Button {
                        handleAccount()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Login" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                            Spacer()
                        }.background(Color.blue)
                    }
                    
                    //Login Message Display
                    
                    Text(self.loginMessage)
                        .foregroundColor(.red)
                    
                    
                    
                    
                    
                    
                    
                }.padding()
                
                
            }
            //title
            .navigationTitle(isLoginMode ? "Login" : "Create Account")
            .background(Color(.init(white:0, alpha: 0.05))
                            .ignoresSafeArea())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    private func handleAccount() {
        if isLoginMode {
            loginAcc()
            print("Log into Firebase w/ email \(email) & password \(password)")
        } else {
            createAcc()
            print("Register new Firebase account w/ email \(email) & password \(password) & image")
        }
    }
    
    
    
    
    
    @State var loginMessage = ""
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
        }
            
        
    }
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
