//
//  SignUpAlerts.swift
//  Sendora
//
//  Created by Youssef Ashraf on 27/07/2025.
//

import SwiftUI



struct AlertView: View {
    var error: AuthError
    @Binding var isShown: Bool
    var isAlertValid: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 25){
            
            Image(systemName: isAlertValid ? "checkmark.circle.fill" : "x.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .padding(.top, 3)
            
            Text("\(error.rawValue)")
                .font(.system(.title2, design: .monospaced))
                
        }
        .padding(25)
        .background(isAlertValid ? .green : .softRed)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding()
        .gesture(
            
            DragGesture()
                
                .onEnded({ value in
                    if value.translation.height > 0 && value.translation.height > 40 {
                            
                        
                        
                        isShown = false
                        
                 
                            
                        
                        
                    }
                })
            
            
        )
        
        
    }
}




#Preview {
    AlertView(error: .verificationEmailSent, isShown: .constant(true), isAlertValid: true)
}
