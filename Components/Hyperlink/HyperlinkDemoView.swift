//
//  HyperlinkView.swift
//  Components
//
//  Created by Steve Tibbett on 2019-10-19.
//

import Foundation
import SwiftUI


struct HyperlinkDemoView: View {
    
    var body: some View {
        VStack {
            Text("You may want to include a hyperlink in text.  There's no built-in way to do this, but this is a method that sort of works.")
                .fixedSize(horizontal: false, vertical: true)
            Divider()
            HStack {
                Text("Click")
                Text("here")
                    .foregroundColor(Color.blue)
                    // Using negative padding here since the default padding is too much.
                    // This should be adjusted dynamically for the font being used.
                    .padding([.leading, .trailing], -4)
                    .onTapGesture {
                        print("Tapped 'here'")
                    }
                Text("to continue.")
            }
            Divider()
        }.frame(minWidth: 400, minHeight: 400)
    }
}

struct HyperlinkView_Previews: PreviewProvider {
    static var previews: some View {
        HyperlinkDemoView()
    }
}
