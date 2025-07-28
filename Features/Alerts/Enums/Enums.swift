
enum AppAlert: Equatable {
    case auth(AuthError)
    
}

enum AuthError: String,Error {
    case invalidEmail = "Invalid Email",
         
    weakPassword = "Password must be at least 8 characters long and include a symbol and an uppercase letter.",
    
    invalidConfPassword = "Passwords must match.",
    
    emailALreadyInUse = "Email is already in use.",
         
    emptyField = "Please fill all required fields.",
    
    unknow = "Unknown error occured, please try again.",
    
    wrongEmailOrPass = "Email or password may not exist.",
         
    wrongPassword = "Wrong password.",
    
    needsVerification = "Please verify you Email first to login.",
    
    verificationEmailSent = "A verification Email has been sent to your Email account."
    
}


