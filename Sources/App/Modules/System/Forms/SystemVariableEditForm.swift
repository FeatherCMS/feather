//
//  SystemVariableEditForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 06. 10..
//

import Vapor
import ViewKit

final class SystemVariableEditForm: Form {

    typealias Model = SystemVariableModel

    struct Input: Decodable {
        var id: String
        var key: String
        var value: String
        var notes: String
    }

    var id: String? = nil
    var key = StringFormField()
    var value = StringFormField()
    var notes = StringFormField()
    var notification: String?
    
    var leafData: LeafData {
        .dictionary([
            "id": id,
            "key": key,
            "value": value,
            "notes": notes,
            "notification": notification,
        ])
    }

    init() {}

    init(req: Request) throws {
        let context = try req.content.decode(Input.self)
        id = context.id.emptyToNil
        key.value = context.key
        value.value = context.value
        notes.value = context.notes
    }
    
    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
       
        if key.value.isEmpty {
            key.error = "Key is required"
            valid = false
        }
        if value.value.isEmpty {
            value.error = "Value is required"
            valid = false
        }

        return req.eventLoop.future(valid)
    }

    func read(from input: Model)  {
        id = input.id!.uuidString
        key.value = input.key
        value.value = input.value
        notes.value = input.notes ?? ""
    }

    func write(to output: Model) {
        output.key = key.value
        output.value = value.value
        output.notes = notes.value.emptyToNil
    }
}

