//
//  Data.swift
//  myNotes21
//
//  Created by Krishna Nanduri on 16/07/20.
//  Copyright © 2020 Krishna Nanduri. All rights reserved.
//

import Foundation

import SQLite3

struct Note: Identifiable {
    let id: Int32
    var content: String
}

class NoteManager {
    var database: OpaquePointer?

    // static member for Views to call
    static let shared = NoteManager()

    private init() {}

    func connect() {
        if database != nil {
            return
        }
        do {
            let databaseURL = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent("notes.sqlite3")

            if sqlite3_open(databaseURL.path, &database) != SQLITE_OK {
                print("Could not connect to Database")
                return
            }

            if sqlite3_exec(
                database,
                """
                CREATE TABLE IF NOT EXISTS notes (
                    content TEXT
                )
                """,
                nil,
                nil,
                nil
            ) != SQLITE_OK {
                print("Could not create Table")
            }
        }
        catch _ {
            print("Could not create Database")
        }
    }

    func create() -> Int {
        connect()

        var statement: OpaquePointer? = nil

        // prepare statement
        if sqlite3_prepare_v2(
            database,
            "INSERT INTO notes (content) VALUES ('New Note')",
            -1,
            &statement,
            nil
        ) != SQLITE_OK {
            print("create(): Could not create Query")
            return -1
        }

        // excecute statement
        if sqlite3_step(statement) != SQLITE_DONE {
            print("create(): Could not insert Note")
            return -1
        }

        // finalize (cleanup)
        sqlite3_finalize(statement)
        return Int(sqlite3_last_insert_rowid(database))
    }

    func getAllNotes() -> [Note] {
        print("print all notes called")
        connect()

        var results: [Note] = []

        var statement: OpaquePointer? = nil

        // prepare statement
        if sqlite3_prepare_v2(
            database,
            "SELECT rowid, content FROM notes",
            -1,
            &statement,
            nil
        ) != SQLITE_OK {
            print("getAllNotes(): Could not create Query")
            return []
        }

        // excecute statement
        while sqlite3_step(statement) == SQLITE_ROW {
            results.append(
                Note(
                    id: Int32(sqlite3_column_int(statement, 0)),
                    content: String(cString: sqlite3_column_text(statement, 1))
                )
            )
        }

        // finalize (cleanup)
        sqlite3_finalize(statement)
        print(results)
        return results
    }

    func saveNote(note: Note) {
        connect()

        var statement: OpaquePointer? = nil
        
        // prepare statement
        if sqlite3_prepare_v2(
            database,
            """
            UPDATE notes
            SET content = ?
            WHERE rowid = ?
            """,
            -1,
            &statement,
            nil
        ) != SQLITE_OK {
            print("saveNote(): Error creating Update Statement")
        }
       
        // bind note.content
        sqlite3_bind_text(
            statement,
            1,
            NSString(string: note.content).utf8String,
            -1,
            nil
        )
        
        // bind note.id
        sqlite3_bind_int(
            statement,
            2,
            note.id
        )

        // excecute statment
        if sqlite3_step(statement) != SQLITE_DONE {
            print("saveNote(): Error running Update")
        }

        // finalize (cleanup)
        sqlite3_finalize(statement)
    }
    
    func deleteNote(note: Note) {
        connect()

        var statement: OpaquePointer? = nil
        
        // prepare statement
        if sqlite3_prepare_v2(
            database,
            """
            DELETE FROM notes
            WHERE rowid = ?
            """,
            -1,
            &statement,
            nil
        ) != SQLITE_OK {
            print("saveNote(): Error creating Delete Statement")
        }
        
        // bind note.id
        sqlite3_bind_int(
            statement,
            1,
            note.id
        )

        // excecute statment
        if sqlite3_step(statement) != SQLITE_DONE {
            print("saveNote(): Error running Delete")
        }

        // finalize (cleanup)
        sqlite3_finalize(statement)
        print("delete successful")
    }
}

