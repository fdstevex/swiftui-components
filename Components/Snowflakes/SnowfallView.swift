//
//  SnowfallView.swift
//  ChristmasGame
//
//  Created by Steve Tibbett on 2019-11-23.
//  Copyright © 2019 Steve Tibbett. All rights reserved.
//

import Foundation
import CoreGraphics
import SwiftUI
import Combine

class SnowflakeInfo: Identifiable {
    var id = UUID()
    var position = CGPoint()
    var size: Double
    var drift = 0.0

    init(position: CGPoint, size: Double) {
        self.position = position
        self.size = size
    }
    
    func update() {
        position.y = position.y + (CGFloat(size)/4)
        position.x += CGFloat(drift)
        drift = drift + (((Double(arc4random()).truncatingRemainder(dividingBy: size*100))-(size*50))/(size*50))
        drift = min(drift, max(drift, -(size/20)), (size/20))
    }
}

class SnowfallController : ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    
    var flakes = [SnowflakeInfo]()
    var snowfieldSize = CGSize()

    // Return a transparent Rectangle so this can be called from a ViewBuilder
    // without having any effect on the view.
    func setSize(_ size: CGSize) -> AnyView {
        snowfieldSize = size
        return AnyView(Rectangle().opacity(0.0))
    }
    
    func addFlake() {
        let position = CGPoint(x: Int(arc4random()%1024), y: 0)
        let size = 0.5 + Double(arc4random()%1024/30)
        flakes.append(SnowflakeInfo(position: position, size: size))
    }
    
    func updateFlakes() {
        DispatchQueue.main.async {
            self.flakes.forEach { $0.update() }
            self.objectWillChange.send()
            self.addFlake()
            self.flakes = self.flakes.filter { $0.position.y < self.snowfieldSize.height }
        }
    }
    
    var timer: Timer?
    
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: {_ in
            self.updateFlakes()
        })
    }
}

struct SnowfallView : View {
    @ObservedObject var controller = SnowfallController()
    
    var body : some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { geometry in
                self.controller.setSize(geometry.size)
                ForEach(self.controller.flakes) { flake in
                    Circle().fill(Color.white).offset(x: flake.position.x, y: flake.position.y)
                        .frame(width: CGFloat(flake.size), height: CGFloat(flake.size))
                }
            }
        }
    }
}
