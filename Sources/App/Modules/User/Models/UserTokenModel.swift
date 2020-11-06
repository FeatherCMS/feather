//
//  UserTokenModel.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 26..
//

import Vapor
import Fluent
import ViperKit

final class UserTokenModel: ViperModel {
    typealias Module = UserModule
    
    static let name = "tokens"
    
    struct FieldKeys {
        static var value: FieldKey { "value" }
        static var userId: FieldKey { "user_id" }
    }
    
    // MARK: - fields
    
    /// unique identifier of the token
    @ID() var id: UUID?
    /// value of the token string
    @Field(key: FieldKeys.value) var value: String
    /// associated user object to the token
    @Parent(key: FieldKeys.userId) var user: UserModel

    init() { }
    
    init(id: UserTokenModel.IDValue? = nil,
         value: String,
         userId: UserModel.IDValue)
    {
        self.id = id
        self.value = value
        self.$user.id = userId
    }
}
