//
//  AdminErrorMiddleware.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 17..
//

import Vapor

struct AdminErrorMiddleware: Middleware {

    /// if we found a .notFound error in the responder chain, we render our custom not found page with a 404 status code
    public func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        next.respond(to: req).flatMapError { error in
            if let abort = error as? AbortError {
                return renderError(req, error: abort).encodeResponse(status: abort.status, for: req)
            }
            return req.eventLoop.future(error: error)
        }
    }

    func renderError(_ req: Request, error: AbortError) -> EventLoopFuture<View> {
        req.leaf.render(template: "Admin/Error", context: [
            "error": [
                "code": .int(Int(error.status.code)),
                "reason": .string(error.reason),
            ]
        ])
    }
}
