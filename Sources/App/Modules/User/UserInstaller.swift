//
//  UserModule+Install.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 07. 12..
//

import FeatherCore

struct UserInstaller: ViperInstaller {

    func createModels(_ req: Request) -> EventLoopFuture<Void>? {
        UserModel(email: "feather@binarybirds.com", password: try! Bcrypt.hash("Feather")).create(on: req.db)
    }
}
