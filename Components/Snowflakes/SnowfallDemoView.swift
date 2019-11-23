//
//  SnowfallDemoView.swift
//  Components
//
//  Created by Steve Tibbett on 2019-11-23.
//  Copyright © 2019 Steve Tibbett. All rights reserved.
//

import Foundation
import SwiftUI

struct SnowfallDemoView : View {
    var body : some View {
        ZStack {
            Rectangle().foregroundColor(Color.red)
            Text("Merry Christmas!")
            SnowfallView()
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

