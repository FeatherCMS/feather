//
//  UserModel+Auth.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 02..
//

import Vapor

/// users can be authenticated using the session storage
extension UserModel: SessionAuthenticatable {
    typealias SessionID = UUID

    var sessionID: SessionID { self.id! }
}

