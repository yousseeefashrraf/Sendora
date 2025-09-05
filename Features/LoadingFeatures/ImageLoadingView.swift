//
//  ImageLoadingView.swift
//  Sendora
//
//  Created by Youssef Ashraf on 04/09/2025.
//

import SwiftUI

struct ImageLoadingView: View {
    var loadingPercentage: CGFloat
    var body: some View {
        ZStack{
    
            GeometryReader { geometry in
                   RoundedRectangle(cornerRadius: 60)
                       .trim(from: 0, to: loadingPercentage)
                       .stroke(Color.green, lineWidth: 10)
                       .rotationEffect(.degrees(-90))
                       .frame(width: geometry.size.height, height: geometry.size.width)
                       .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
               }
        }
        .ignoresSafeArea()
                
    }
}

#Preview {
    ImageLoadingView(loadingPercentage: 0.7)
}
