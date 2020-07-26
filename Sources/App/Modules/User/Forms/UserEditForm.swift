//
//  UserEditForm.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

import Vapor
import ViewKit

final class UserEditForm: Form {

    typealias Model = UserModel

    struct Input: Decodable {
        var id: String
        var email: String
        var password: String
    }

    var id: String? = nil
    var email = BasicFormField()
    var password = BasicFormField()
    
    var notification: String?

    init() {
        self.initialize()
    }

    init(req: Request) throws {
        self.initialize()

        let context = try req.content.decode(Input.self)
        self.id = context.id.emptyToNil

        self.email.value = context.email
        self.password.value = context.password
    }
    
    func initialize() {
        
    }
    
    func read(from model: Model)  {
        self.id = model.id!.uuidString
        self.email.value = model.email
        self.password.value = ""
    }

    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
       
        if Validator.email.validate(self.email.value).isFailure {
            self.email.error = "Invalid email"
            valid = false
        }

        if self.id == nil && Validator.count(8...).validate(self.password.value).isFailure {
            self.password.error = "Password is too short"
            valid = false
        }
        return req.eventLoop.future(valid)
    }
    
    func write(to model: Model) {
        model.email = self.email.value
        if !self.password.value.isEmpty {
            model.password = try! Bcrypt.hash(self.password.value)
        }
    }
}
