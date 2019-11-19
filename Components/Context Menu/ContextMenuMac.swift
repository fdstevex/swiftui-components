//
//  ContextMenuMac.swift
//  ComponentsMac
//
//  Created by Steve Tibbett on 2019-11-19.
//  Copyright © 2019 Steve Tibbett. All rights reserved.
//

import Foundation
import SwiftUI

struct ContextMenuMac : View {
    var body : some View {
        HStack(alignment: .center) {
            Spacer()
            MenuButton("Menu") {
                Button(action: {
                    print("Clicked first item")
                }) {
                    Text("First item")
                }
                Button(action: {
                    print("Clicked second item")
                }) {
                    Text("Second item")
                }
            }.menuButtonStyle(BorderlessButtonMenuButtonStyle())
        }.frame(minWidth: 300, minHeight: 300)
    }
}

