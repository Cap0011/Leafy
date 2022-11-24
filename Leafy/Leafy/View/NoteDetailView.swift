//
//  NoteDetailView.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/11/24.
//

import SwiftUI

struct NoteDetailView: View {
    let journal: String
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 2)
                .foregroundColor(Color("Unselected"))
                .frame(width: 50, height: 4)
                .padding(.top, 12)
            
            ScrollView(showsIndicators: false) {
                ZStack(alignment: .top) {
                    VStack(spacing: 40) {
                        ForEach(0..<13, id: \.self) { _ in
                            MyUnderline()
                        }
                    }
                    .padding(.top, 30)
                    
                    Text(journal)
                        .font(.custom(FontManager.hand, size: 20))
                        .lineSpacing(17)
                }
                .padding(.top, 40)
                .padding(.horizontal, 48)
            }
        }
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NoteDetailView(journal: "잎이 조금 시들시들한 것 같아 오늘 물을 줬다. 앞 으로 물 주는 주기를 조금 짧게 잡아야겠다. 앞으로도 잘 자라주었으면 좋겠는데 한번 비료를 사서 줘봐야지. 잎이 조금 시들시들한 것 같아 오늘 물을 줬다. 앞 으로 물 주는 주기를 조금 짧게 잡아야겠다. 앞으로도 잘 자라주었으면 좋겠는데 한번 비료를 사서 줘봐야지. 잎이 조금 시들시들한 것 같아 오늘 물을 줬다. 앞 으로 물 주는 주기를 조금 짧게 잡아야겠다. 앞으로도 잘 자라주었으면 좋겠는데 한번 비료를 사서 줘봐야지. 잎이 조금 시들시들한 것 같아 오늘 물을 줬다. 앞 으로 물 주는 주기를 조금 짧게 잡아야겠다. 앞으로도 잘 자라주었으면 좋겠는데 한번 비료를 사서 줘봐야지. 잎이 조금 시들시들한 것 같아 오늘 물을 줬다. 앞 으로 물 주는 주기를 조금 짧게 잡아야겠다. 앞으로도 잘 자라주었으면 좋겠는데 한번 비료를 사서 줘봐야지. 잎이 조금 시들시들한 것 같아 오늘 물을 줬다. 앞 으로 물 주는 주기를 조금 짧게 잡아야겠다. 앞으로도 잘 자라주었으면 좋겠는데 한번 비료를 사서 줘봐야지. 잎이 조금 시들시들한 것 같아 오늘 물을 줬다. 앞 으로 물 주는 주기를 조금 짧게 잡아야겠다. 앞으로도 잘 자라주었으면 좋겠는데 한번 비료를 사서 줘봐야지. 잎이 조금 시들시들한 것 같아 오늘 물을 줬다. 앞 으로 물 주는 주기를 조금 짧게 잡아야겠다. 앞으로도 잘 자라주었으면 좋겠는데 한번 비료를 사서 줘봐야지. 잎이 조금 시들시들한 것 같아 오늘 물을 줬다. 앞 으로 물 주는 주기를 조금 짧게 잡아야겠다. 앞으로도 잘 자라주었으면 좋겠는데 한번 비료를 사서 줘봐야지.")
    }
}
