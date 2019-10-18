//
//  ContentView.swift
//  KeypadSample
//
//  Created by Steve Tibbett on 2019-10-12.
//  Copyright © 2019 Steve Tibbett. All rights reserved.
//

import SwiftUI

struct LockState {
    let correctCode = "7492"
    var currentCode = ""
}

// Keypad button .. calls clickHandler when clicked.
struct KeypadButton: View {
    init(_ label: String, _ clickHandler: @escaping (String)->()) {
        self.clickHandler = clickHandler
        self.label = label
    }
    
    var label = ""
    var clickHandler: ((String)->())?
    
    var body: some View {
        ZStack() {
            Button(action: { self.clickHandler?(self.label) }) {
                ZStack() {
                    Text(label)
                        .frame(width: 80, height: 80, alignment: .center)
                        .font(Font.custom("Helvetica-Bold", size: 60))
                        .foregroundColor(Color.white)
                        .padding(.top, 8)
                }
            }.background(Color.black)
        }.background(Color.black).border(Color.gray, width: 2)
    }
}

// Keypad - lays out the buttons in a grid,
// calls inputHandler on taps.
struct Keypad: View {
    init(_ inputHandler: @escaping (String)->()) {
        self.inputHandler = inputHandler
    }
    
    var inputHandler: ((String)->()) = { _ in }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                KeypadButton("1", inputHandler)
                KeypadButton("2", inputHandler)
                KeypadButton("3", inputHandler)
            }
            HStack(spacing: 10) {
                KeypadButton("4", inputHandler)
                KeypadButton("5", inputHandler)
                KeypadButton("6", inputHandler)
            }
            HStack(spacing: 10) {
                KeypadButton("7", inputHandler)
                KeypadButton("8", inputHandler)
                KeypadButton("9", inputHandler)
            }
            HStack(spacing: 10) {
                KeypadButton("", inputHandler)
                KeypadButton("0", inputHandler)
                KeypadButton("🔙", inputHandler)
            }
        }
    }
}

// Keypad view - shows the keypad, handles taps, plays sounds.
struct KeypadView: View {
    @State var state = LockState()

    private var successfulCompletionCallback: (()->())?
    
    init(successfulCompletionCallback: @escaping ()->()) {
        self.successfulCompletionCallback = successfulCompletionCallback
    }
    
    var body: some View {
        ZStack() {
            Spacer().frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            VStack(alignment: .center) {
                Spacer().frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                Text(state.currentCode.isEmpty ? NSLocalizedString("Enter Code", comment: "Keypad Code Placeholder") : state.currentCode).foregroundColor(Color.red).font(Font.custom("Helvetica-Bold", size: 40))
                Keypad() { str in
                    if str == "🔙" {
                        self.reset()
                    }

                    if let value = Int(str) {
                        self.tappedCode(value)
                    }
                }
            Spacer().frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            }
        }.background(Color.black)
    }

    private func reset() {
        state = LockState()
    }
    
    private func tappedCode(_ value: Int) {
        guard state.currentCode.count < 4 else {
            SoundPlayer.shared.play("keypad-error")
            return
        }
        
        state.currentCode.append("\(value)")
        if state.currentCode == state.correctCode {
            SoundPlayer.shared.play("keypad-good")
            self.successfulCompletionCallback?()
            return
        }
        
        if state.currentCode.count == 4 {
            SoundPlayer.shared.play("keypad-error")
        } else {
            SoundPlayer.shared.play("keypad-tap")
        }
    }
}


struct KeypadContainerView: View {
    @State var codeEntered = false

    // Produde the view for this ContentView
    var body: some View {
        // Instantiate the keypad.
        // It will be in the center of the view.
        Group {
            if codeEntered {
                Text("Welcome")
            } else {
                KeypadView() {
                    // Correct code entered - set the flag that shows the other view.
                    self.codeEntered = true
                }
            }
        }
    }
}

struct KeypadView_Previews: PreviewProvider {
    static var previews: some View {
        KeypadContainerView()
    }
}
