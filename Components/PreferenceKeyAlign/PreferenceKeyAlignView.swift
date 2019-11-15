//
//  PreferenceKeyAlignView.swift
//  Components
//
//  Created by Steve Tibbett on 2019-11-15.
//  Copyright © 2019 Steve Tibbett. All rights reserved.
//

import Foundation
import SwiftUI

// Credit for much of this goes to Keith Lander
// https://medium.com/better-programming/using-the-preferencekey-protocol-to-align-views-7f3ae32f60fc

struct ColumnWidthPreference: Equatable {
    let width: CGFloat
}

struct ColumnWidthPreferenceKey: PreferenceKey {
    typealias Value = [ColumnWidthPreference]

    static var defaultValue: [ColumnWidthPreference] = []

    static func reduce(value: inout [ColumnWidthPreference], nextValue: () -> [ColumnWidthPreference]) {
        value.append(contentsOf: nextValue())
    }
}

struct ColumnMeasurer: View {
    var body: some View {
        GeometryReader { geometry in
            Text("")
                .background(Color.clear)
                .preference(
                    key: ColumnWidthPreferenceKey.self,
                    value: [ColumnWidthPreference(width: geometry.frame(in: CoordinateSpace.global).width)]
                )
        }
    }
}

struct BeforeView: View {
    var body: some View {
        Form {
            HStack(alignment: .top) {
                Text("First label:")
                Text("Value One")
            }
            HStack(alignment: .top) {
                Text("Label two:")
                Text("Value Two\nBut with an embedded newline")
            }
            HStack(alignment: .top) {
                Text("The third label:")
                Text("Value Three")
            }
        }
    }
}

struct RightAlignedLabel: View {
    var text: String
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Text(text)
        }.background(ColumnMeasurer())
    }
}

struct ColumnWidth: ViewModifier {
    @Binding var width: CGFloat?
    func body(content: Content) -> some View {
    content
        .onPreferenceChange(ColumnWidthPreferenceKey.self) { preferences in
            self.width = preferences.map { $0.width }.max()
        }
    }
}

struct AfterView: View {
    @State var width: CGFloat? = nil
    var body: some View {
        Form {
            // Now it's a VStack of HStacks, which keeps
            // variable-height rows from messing up the row
            // arrangement between the labels and the values
            HStack(alignment: .top) {
                Text("First label:").frame(width: width, alignment: .trailing).background(ColumnMeasurer())
                Text("Value One")
            }
            HStack(alignment: .top) {
                Text("Label two:").frame(width: width, alignment: .trailing).background(ColumnMeasurer())
                Text("Value Two\nBut with an embedded newline")
            }
            HStack(alignment: .top) {
                Text("The third label:").frame(width: width, alignment: .trailing).background(ColumnMeasurer())
                Text("Value Three")
            }
        }.modifier(ColumnWidth(width:$width))
    }
}

struct PreferenceKeyAlignView: View {
    var body: some View {
        VStack(spacing: 10) {
            VStack {
                Text("Before").font(.headline).padding(.bottom, 10)
                BeforeView()
            }.padding()
             .border(Color.black)

            VStack {
                Text("After, using PreferenceKey").font(.headline).padding(.bottom, 10)
                AfterView()
            }.padding()
             .border(Color.black)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
