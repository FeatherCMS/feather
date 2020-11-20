//
//  UserModel.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

import Vapor
import Fluent
import ViperKit

final class UserModel: ViperModel {
    typealias Module = UserModule
    
    static let name = "users"

    struct FieldKeys {
        
        static var email: FieldKey { "email" }
        static var password: FieldKey { "password" }
    }
    
    // MARK: - fields
    
    /// unique identifier of the model
    @ID() var id: UUID?
    /// email address of the user
    @Field(key: FieldKeys.email) var email: String
    /// hashed password of the user
    @Field(key: FieldKeys.password) var password: String
    
    init() { }
    
    init(id: UserModel.IDValue? = nil,
         email: String,
         password: String)
    {
        self.id = id
        self.email = email
        self.password = password
    }
}

