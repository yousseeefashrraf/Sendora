
enum AppAlert: Equatable {
    case auth(AuthError)
    case upload(UploadError)
}

enum AuthError: String,Error {
    case invalidEmail = "Invalid Email",
         
    weakPassword = "Password must be at least 8 characters long and include a symbol and an uppercase letter.",
    
    invalidConfPassword = "Passwords must match.",
    
    emailALreadyInUse = "Email is already in use.",
         
    emptyField = "Please fill all required fields.",
    
    unknow = "Unknown error occured, please try again.",
    
    cancelled = "Signing in is canceled.",
    
    wrongEmailOrPass = "Email or password may not exist.",
         
    wrongPassword = "Wrong password.",
    
    needsVerification = "Please verify you Email first to login.",
    
    verificationEmailSent = "A verification Email has been sent to your Email account."
    
}

enum UploadError: String, Error{
    case image = "Error while trying to upload the image."
}
enum FirestoreError: String, Error{
    case invalidReadOperatioin = "Error fetching data. Please try again later.",
    invalidCreateOperating = "Error creating data. Please try again later." // will change based on the operation type ferther on by including a variable in the Collections 
}


