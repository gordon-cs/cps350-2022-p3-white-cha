
//TODO
=
* Screens
  * Individual Chat Screen

* Functional Components
  * New Message Button needs to be linked to new 'tickets'
  * Light/Dark mode toggle button needs to be linked to ".preferedColorScheme( [colorscheme] )"
    * probably means we either need to use default dark mode or create a colorscheme
 

* Services
  * Chat tabs have to be linked to SPECIFIC users (SFS/CTS)
    * Ideas: 
      * probably can be done via making a seperate folder in firebase storage for service accounts
      * registration could add an "admin" section that requires certain password to create service acc
    * only issue would be that it may detract from user experience
      * could also be done via making a key phrase in the username give access to "service" account
      * i.e. cts-service@gordon.edu
      * this could work for gordon services as all student accounts would have firstname.lastname@gordon.edu
    * however, this would not work for other services outside of gordon (this may not matter)
      


(once Individual Chat Screen template has been made, we can proceed with further functional components/services)


//DONE
=


* Usable Features
  * Account Creation
  * Login via firebase Authentication
  * Image selection and storage via firebase Storage
  * Upon Account Authentication, login/registration screen is dismissed to show main message view
  * Upon logout from main message view, login/registration screen is shown
 
 
* Screens
  * Log-in/Registration
  * All Message View

* Functional Components
  * Cryptographic Hashing
  * Firebase linker (firebaseManager)

* Active Services
  * Firebase Authentication
  * Firebase Account Creation
  * Firebase Image Storage





