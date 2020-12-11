//
//  ContentView.swift
//  myNotes21
//
//  Created by Krishna Nanduri on 16/07/20.
//  Copyright © 2020 Krishna Nanduri. All rights reserved.
//

import SwiftUI

struct NoteListView: View {
    @State var notes: [Note] = []
    
    func reload() {
        notes = NoteManager.shared.getAllNotes()
    }
    
    func createNote() {
        let result = NoteManager.shared.create()
        
        if result == -1 {
            print("Note creation unsuccessfull")
            return
        }
        
        print("Note creation successfull")
        reload()
    }
    
    func deleteNote(at offsets: IndexSet) {
        let p = offsets.first ?? -1
        print(p)
        if p == -1 {
            print("invalid index")
            return
        }
        NoteManager.shared.deleteNote(note: notes[p])
        reload()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(notes) {
                        note in
                        NavigationLink(destination: NoteDetail(note: note)) {
                                NoteRow(note: note)
                        }
                    }
                    .onDelete(perform: deleteNote)
                }
                .navigationBarTitle("myNotes21", displayMode: .inline)
                .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                    print("New Note Button Pressed")
                    self.createNote()
                    
                }) {
                    Image(systemName: "plus")
                })
                .onAppear {
                    print("NoteListView onAppear Triggered")
                    self.reload()
                }
            }
        }
    }
}

struct NoteList_Previews: PreviewProvider {
    static var previews: some View {
        NoteListView()
    }
}
