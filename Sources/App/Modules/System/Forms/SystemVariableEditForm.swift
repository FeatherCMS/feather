//
//  SystemVariableEditForm.swift
//  FeatherCMS
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
    var key = BasicFormField()
    var value = BasicFormField()
    var notes = BasicFormField()
    
    var notification: String?

        
    init() {
        self.initialize()
    }

    init(req: Request) throws {
        self.initialize()

        let context = try req.content.decode(Input.self)
        self.id = context.id.emptyToNil

        self.key.value = context.key
        self.value.value = context.value
        self.notes.value = context.notes
    }
    
    func initialize() {

    }
    
    func read(from model: Model)  {
        self.id = model.id!.uuidString
        self.key.value = model.key
        self.value.value = model.value
        self.notes.value = model.notes ?? ""
    }

    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
       
        if self.key.value.isEmpty {
            self.key.error = "Key is required"
            valid = false
        }
        if self.value.value.isEmpty {
            self.value.error = "Value is required"
            valid = false
        }

        return req.eventLoop.future(valid)
    }
    
    func write(to model: Model) {
        model.key = self.key.value
        model.value = self.value.value
        model.notes = self.notes.value.emptyToNil
    }
}
