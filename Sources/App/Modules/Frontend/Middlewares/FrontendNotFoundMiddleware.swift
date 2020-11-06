//
//  FrontendNotFoundMiddleware.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 04. 07..
//

import FeatherCore

struct FrontendNotFoundMiddleware: Middleware {

    /// if we found a .notFound error in the responder chain, we render our custom not found page with a 404 status code
    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        next.respond(to: request).flatMapError { error in
            if let abort = error as? AbortError, abort.status == .notFound {
                return notFound(request)
            }
            return request.eventLoop.future(error: error)
        }
    }

    func notFound(_ req: Request) -> EventLoopFuture<Response> {
        req.leaf.render(template: "Frontend/NotFound").flatMap { $0.encodeResponse(status: .notFound, for: req) }
    }
}
