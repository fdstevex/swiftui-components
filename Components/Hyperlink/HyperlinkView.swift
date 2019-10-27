//
//  HyperlinkView.swift
//  Components
//
//  Created by Steve Tibbett on 2019-10-19.
//

import Foundation
import SwiftUI

struct HyperlinkView: View {
    var body: some View {
        VStack {
            Text("You may want to include a hyperlink in text.  There's no built-in way to do this.  But one hack is to use a VStack and buttons.")
                .fixedSize(horizontal: false, vertical: true)
            Divider()
            Text("For example:")
            Divider()
            HStack {
                Text("Click")
                Button("here", action: {})
                Text("to continue.")
            }
            Divider()
            Text("This isn't great (and doesn't work right on the Mac).  I'll update this sample when I discover a better way." )
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct HyperlinkView_Previews: PreviewProvider {
    static var previews: some View {
        HyperlinkView()
    }
}
