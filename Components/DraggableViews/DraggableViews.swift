//
//  DraggableView.swift
//  Components
//
//  Created by Steve Tibbett on 5019-10-26.
//

import Foundation
import SwiftUI

// Shows how you can drag an object by updating it's position using a drag gesture.

class DraggableEmoji : ObservableObject, Identifiable {
    // Identifiable requires a unique 'id' property
    var id = UUID()
    
    var emoji: String

    // The view we're dragging .. in this csae just a Text object with a large emoji
    var view: some View {
        get {
            return Text(emoji).font(.custom("Apple Color Emoji", size: CGFloat(100)))
        }
    }
    
    // Base position for this item
    @Published var position = CGPoint()
    
    // Updated offset during a drag
    @Published var offset = CGSize()
    
    init(emoji: String, position: CGPoint) {
        self.emoji = emoji
        self.position = position
    }
}

struct DragImageView : View {
    @ObservedObject var draggable: DraggableEmoji

    private var dragCompleteHandler: ()->()
    
    init(draggable: DraggableEmoji, dragComplete: @escaping ()->()) {
        self.draggable = draggable
        self.dragCompleteHandler = dragComplete
    }
    
    var body: some View {
        let dragGesture = DragGesture().onChanged({ (value) in
            // Translation is the offset since the start of the drag .. we can't just add it to the position
            // or it will accumulate on every update, so we remember the offset from the base position.
            self.draggable.offset = value.translation
        }).onEnded({ (value) in
            // Save the new position and clear the offset
            self.draggable.position = CGPoint(x: self.draggable.position.x + self.draggable.offset.width, y: self.draggable.position.y + self.draggable.offset.height)
            self.draggable.offset = CGSize()
            self.dragCompleteHandler()
        })

        // Return the draggable's view with the current offset and the drag gesture.
        return draggable.view
            .position(CGPoint(x: draggable.position.x + draggable.offset.width, y: draggable.position.y + draggable.offset.height))
            .gesture(dragGesture)
        }
}

struct DraggableContainerView: View {
    @State var state = [
        DraggableEmoji(emoji: "😮", position: CGPoint(x: 50, y:50)),
        DraggableEmoji(emoji: "❤️", position: CGPoint(x: 150, y: 50)),
        DraggableEmoji(emoji: "🤡", position: CGPoint(x: 50, y: 150)),
        DraggableEmoji(emoji: "🐔", position: CGPoint(x: 150, y: 150)),
        DraggableEmoji(emoji: "🍎", position: CGPoint(x: 250, y: 150)),
        DraggableEmoji(emoji: "🍩", position: CGPoint(x: 150, y: 250)),
        DraggableEmoji(emoji: "🎰", position: CGPoint(x: 250, y: 250))
    ]

    var body: some View {
        ZStack {
            // Stretch the ZStack to the edges of the view with a lovely green background
            Color.green.edgesIgnoringSafeArea([.top, .bottom]).frame(maxWidth: .infinity, maxHeight: .infinity)

            // Add the draggable images - use ForEach to transform the array into views.
            // The closure is handed each item in the array, and returns a view representing the item.
            ForEach(state) { draggable in
                DragImageView(draggable:draggable, dragComplete: {
                    print("Dropped \(draggable.emoji)")
                })
            }
        }
    }
}

