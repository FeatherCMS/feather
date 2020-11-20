//
//  SystemInstallGuardMiddleware.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 14..
//

import Vapor

/// if the system is not installed we only allow system related operations
public struct SystemInstallGuardMiddleware: Middleware {

    /// only allow the root path or the /system/ paths if the system has benn not installed yet, otherwise redirect to the root
    public func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        let installed = req.variables.get("system.installed") == "true"
        if !installed && req.url.path != "/system/install/" && req.url.path != "/" {
            return req.eventLoop.future(req.redirect(to: "/"))
        }
        return next.respond(to: req)
    }
    
}
