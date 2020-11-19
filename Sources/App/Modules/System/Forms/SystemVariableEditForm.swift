//
//  SystemVariableEditForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 06. 10..
//

import Vapor
import ViewKit

final class SystemVariableEditForm: ModelForm {

    typealias Model = SystemVariableModel

    struct Input: Decodable {
        var modelId: String
        var key: String
        var value: String
        var notes: String
    }

    var modelId: String? = nil
    var key = StringFormField()
    var value = StringFormField()
    var notes = StringFormField()
    var notification: String?
    
    var leafData: LeafData {
        .dictionary([
            "modelId": modelId,
            "key": key,
            "value": value,
            "notes": notes,
            "notification": notification,
        ])
    }

    init() {}

    init(req: Request) throws {
        let context = try req.content.decode(Input.self)
        modelId = context.modelId.emptyToNil
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
        if Validator.count(...250).validate(key.value).isFailure {
            key.error = "Key is too long (max 250 characters)"
            valid = false
        }

        return req.eventLoop.future(valid)
    }

    func read(from input: Model)  {
        modelId = input.id?.uuidString
        key.value = input.key
        value.value = input.value ?? ""
        notes.value = input.notes ?? ""
    }

    func write(to output: Model) {
        output.key = key.value
        output.value = value.value.emptyToNil
        output.notes = notes.value.emptyToNil
        output.hidden = false
    }
}

