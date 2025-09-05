//
//  LoadinView.swift
//  Sendora
//
//  Created by Youssef Ashraf on 04/09/2025.
//

import SwiftUI
import Combine
struct LoadingView: View {
    @State var scale = 1.0
    private let timer = Timer.TimerPublisher(interval: 0.5, runLoop: .current, mode: .default).autoconnect()
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(x: scale, y: scale)
                    .rotationEffect(.degrees(scale == 1 ? 0 : scale * 45))
            
        

        }
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                scale += scale == 2 ? 15.0 : scale >= 10 ? 0.0 : 1.0
            }
           
        }
        
    }
}

#Preview {
    LoadingView()
}
