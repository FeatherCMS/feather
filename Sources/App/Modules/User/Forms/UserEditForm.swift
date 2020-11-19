//
//  UserEditForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

import FeatherCore

final class UserEditForm: ModelForm {

    typealias Model = UserModel

    struct Input: Decodable {
        var modelId: String
        var email: String
        var password: String
    }

    var modelId: String? = nil
    var email = StringFormField()
    var password = StringFormField()
    var notification: String?
    
    var leafData: LeafData {
        .dictionary([
            "modelId": modelId,
            "email": email,
            "password": password,
            "notification": notification,
        ])
    }

    init() {}

    init(req: Request) throws {
        let context = try req.content.decode(Input.self)
        modelId = context.modelId.emptyToNil
        email.value = context.email
        password.value = context.password
    }
    
    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
       
        if Validator.email.validate(email.value).isFailure {
            email.error = "Invalid email"
            valid = false
        }
        if Validator.count(...250).validate(email.value).isFailure {
            email.error = "Email is too long (max 250 characters)"
            valid = false
        }
        if modelId == nil && Validator.count(8...).validate(password.value).isFailure {
            password.error = "Password is too short (min 8 characters)"
            valid = false
        }
        if Validator.count(...250).validate(password.value).isFailure {
            password.error = "Password is too long (max 250 characters)"
            valid = false
        }
        return req.eventLoop.future(valid)
    }

    func read(from input: Model)  {
        modelId = input.id?.uuidString
        email.value = input.email
        password.value = ""
    }
    
    func write(to output: Model) {
        output.email = email.value
        if !password.value.isEmpty {
            output.password = try! Bcrypt.hash(password.value)
        }
    }
}
