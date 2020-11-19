//
//  UserLoginForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 02. 20..
//

import FeatherCore

final class UserLoginForm: Form {

    struct Input: Decodable {
        var email: String
        var password: String
    }
    
    var email = StringFormField()
    var password = StringFormField()
    var notification: String?

    var leafData: LeafData {
        .dictionary([
            "email": email,
            "password": password,
            "notification": notification,
        ])
    }

    init() {}

    init(req: Request) throws {
        let context = try req.content.decode(Input.self)
        email.value = context.email
        password.value = context.password
    }

    func validate(req: Request) -> EventLoopFuture<Bool> {
        let valid = !Validator.email.validate(email.value).isFailure &&
            !Validator.count(8...).validate(password.value).isFailure

        if !valid {
            notification = "Invalid username or password"
        }
        return req.eventLoop.future(valid)
    }
}
