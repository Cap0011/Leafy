//
//  File.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/10/16.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
}
