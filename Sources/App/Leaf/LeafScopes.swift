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
            try req.leaf.context.register(generators: req.leafMenuVariables, toScope: "menus")
        }
        catch {
            return req.eventLoop.makeFailedFuture(error)
        }
        return next.respond(to: req)
    }
}


/// NOTE: this is a module dependency, that should be eliminated somehow in the future
extension Request {
    var leafMenuVariables: [String: LeafDataGenerator] {
        menus.all.mapValues { .lazy(LeafData($0)) }
    }
}
