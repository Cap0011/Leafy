//
//  NoteImageView.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/11/24.
//

import SwiftUI

struct NoteImageView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let image: Image?
    
    var body: some View {
        ZStack(alignment: .center) {
            Color("Black").ignoresSafeArea()
                if let image = image {
                    image
                        .resizable()
                        .rotationEffect(.degrees(90))
                        .scaledToFit()
                }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
            }
        }
    }
}

struct NoteImageView_Previews: PreviewProvider {
    static var previews: some View {
        NoteImageView(image: Image("PlaceHolder"))
    }
}
