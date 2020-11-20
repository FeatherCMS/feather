//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 04..
//

import FeatherCore


struct LeafFeatherExtensionMiddleware: Middleware {

    public init() {}

    public func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {

        do {
            try req.leaf.context.register(generators: req.application.leafFeatherVariables, toScope: "app")
            try req.leaf.context.register(generators: req.leafSystemVariables, toScope: "vars")
            try req.leaf.context.register(generators: req.leafUserVariables, toScope: "user")
            try req.leaf.context.register(generators: req.leafMenuVariables, toScope: "menus")
        }
        catch {
            return req.eventLoop.makeFailedFuture(error)
        }
        return next.respond(to: req)
    }
}

extension Application {
    var leafFeatherVariables: [String: LeafDataGenerator] {
        [
            "baseUrl": .immediate(LeafData.string(Application.baseUrl)),
            "timezone": .lazy(Application.Config.timezone.identifier),
            "locale": .lazy(Application.Config.locale.identifier),
            "dateFormats": .lazy([
                "full": LeafData.string(Application.Config.dateFormatter().dateFormat),
                "date": LeafData.string(Application.Config.dateFormatter(timeStyle: .none).dateFormat),
                "time": LeafData.string(Application.Config.dateFormatter(dateStyle: .none).dateFormat),
            ]),
        ]
    }
}

/// NOTE: this is a module dependency, that should be eliminated somehow in the future
extension Request {

    var leafSystemVariables: [String: LeafDataGenerator] {
        variables.all.mapValues { .lazy(LeafData.string($0)) }
    }
    
    var leafUserVariables: [String: LeafDataGenerator] {
        var res: [String: LeafDataGenerator] = [
            "isAuthenticated": .lazy(LeafData.bool(self.auth.has(UserModel.self)))
        ]
        if let user = try? auth.require(UserModel.self) {
            res["email"] = .lazy(LeafData.string(user.email))
        }
        return res
    }
    
    var leafMenuVariables: [String: LeafDataGenerator] {
        menus.all.mapValues { .lazy(LeafData($0)) }
    }
}
