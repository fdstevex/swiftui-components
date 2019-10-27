//
//  ContentView.swift
//  Components
//
//  Created by Steve Tibbett on 2019-10-15.
//

import SwiftUI

enum Samples {
    case none
    case keypad
    case hyperlink
    case drag
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
            Button(action: { self.selected = .drag }) {
                Text("Drag")
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
        case .drag:
            return AnyView(DraggableContainerView())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
