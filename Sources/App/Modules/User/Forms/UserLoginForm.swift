//
//  UserLoginForm.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 02. 20..
//

import Vapor
import ViewKit

final class UserLoginForm: Form {
    typealias Model = UserModel

    struct Input: Decodable {
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
        self.email.value = context.email
        self.password.value = context.password
    }
    
    func initialize() {

    }

    func read(from model: Model)  {
        self.email.value = model.email
        self.password.value = ""
    }

    func validate(req: Request) -> EventLoopFuture<Bool> {
        let valid = !Validator.email.validate(self.email.value).isFailure &&
            !Validator.count(8...).validate(self.password.value).isFailure

        if !valid {
            self.notification = "Invalid username or password"
        }

        return req.eventLoop.future(valid)
    }
    
    func write(to model: Model) {
        model.email = self.email.value
        model.password = try! Bcrypt.hash(self.password.value)
    }
}
