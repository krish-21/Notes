//
//  NoteDetail.swift
//  myNotes21
//
//  Created by Krishna Nanduri on 16/07/20.
//  Copyright © 2020 Krishna Nanduri. All rights reserved.
//

import SwiftUI

struct NoteDetail: View {
    @State var note: Note
    @State var textHeight: CGFloat = 150
    
    @State var text: String = ""
    
    var body: some View {
        ScrollView {
            TextView(placeholder: "Enter Note", text: self.$text, minHeight: self.textHeight, calculatedHeight: self.$textHeight)
                .padding(.top, 5)
                .frame(minHeight: self.textHeight, maxHeight: self.textHeight)
        }
        .onAppear {
            self.text = self.note.content
        }
        .onWillDisappear {
            print("going to dissapear")
            NoteManager.shared.saveNote(note: Note(id: self.note.id, content: self.text))
        }
    }
}


// viewWillDissapear() is absent in SwiftUI: https://stackoverflow.com/a/59746380

struct WillDisappearHandler: UIViewControllerRepresentable {
    func makeCoordinator() -> WillDisappearHandler.Coordinator {
        Coordinator(onWillDisappear: onWillDisappear)
    }

    let onWillDisappear: () -> Void

    func makeUIViewController(context: UIViewControllerRepresentableContext<WillDisappearHandler>) -> UIViewController {
        context.coordinator
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<WillDisappearHandler>) {
    }

    typealias UIViewControllerType = UIViewController

    class Coordinator: UIViewController {
        let onWillDisappear: () -> Void

        init(onWillDisappear: @escaping () -> Void) {
            self.onWillDisappear = onWillDisappear
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            onWillDisappear()
        }
    }
}

struct WillDisappearModifier: ViewModifier {
    let callback: () -> Void

    func body(content: Content) -> some View {
        content
            .background(WillDisappearHandler(onWillDisappear: callback))
    }
}

extension View {
    func onWillDisappear(_ perform: @escaping () -> Void) -> some View {
        self.modifier(WillDisappearModifier(callback: perform))
    }
}

struct NoteDetail_Previews: PreviewProvider {
    static var previews: some View {
        NoteDetail(note: Note(id: 0, content: "Content"))
    }
}
