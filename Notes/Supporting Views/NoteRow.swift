//
//  NoteRow.swift
//  myNotes21
//
//  Created by Krishna Nanduri on 16/07/20.
//  Copyright © 2020 Krishna Nanduri. All rights reserved.
//

import SwiftUI

struct NoteRow: View {
    var note: Note
    
    var body: some View {
        Text(note.content.count > 13 ? note.content.prefix(10) + "..." : note.content)
    }
}

struct NoteRow_Previews: PreviewProvider {
    static var previews: some View {
        NoteRow(note: Note(id: 0, content: "Content"))
    }
}
