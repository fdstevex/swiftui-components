//
//  ContentView.swift
//  Components
//
//  Created by Steve Tibbett on 2019-10-15.
//  Copyright © 2019 Steve Tibbett. All rights reserved.
//

import SwiftUI

enum Samples {
    case none
    case keypad
    case hyperlink
}

struct SampleMenu : View {
    @Binding var selected: Samples
    
    var body: some View {
        VStack {
            Button(action: { self.selected = .keypad }) {
                Text("Keypad")
            }
            Button(action: { self.selected = .hyperlink }) {
                Text("Hyperlink")
            }
        }
    }
}

struct ContentView: View {
    @State var selectedSample = Samples.none
    
    var body: some View {
        switch selectedSample {
        case .none:
            return AnyView(SampleMenu(selected: $selectedSample))
        case .keypad:
            return AnyView(KeypadContainerView())
        case .hyperlink:
            return AnyView(HyperlinkView())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
