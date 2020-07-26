//
//  UserModule+Install.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 07. 12..
//

import Vapor
import Fluent

extension UserModule {

    func installHook(req: Request) -> EventLoopFuture<Any?>? {
        //req.eventLoop.flatten([
            self.installSampleContent(req)
        //])
        .map { $0 as Any }
    }

    func installSampleContent(_ req: Request) -> EventLoopFuture<Void> {
        
        //let u1 = UserModel(email: "feather@binarybirds.com", password: try! Bcrypt.hash("FeatherCMS"))
        let u1 = UserModel(email: "feather@binarybirds.com", password: "$2b$12$7RZSLrxoK0/mOIYuNM0g3OKlyxvFlWgp8wYcIbFmWVJRGARlVB01u")

        return req.eventLoop.flatten([
            [u1].create(on: req.db),
        ])
    }

}
