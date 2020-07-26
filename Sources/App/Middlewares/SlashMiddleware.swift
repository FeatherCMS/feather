//
//  SlashMiddleware.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 02. 16..
//

import Vapor

final class SlashMiddleware: Middleware {

    public func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        let newPath = req.url.path.safePath()
        if req.url.path != newPath {
            return req.eventLoop.future(req.redirect(to: newPath))
        }
        return next.respond(to: req)
    }
}
