//
//  FrontendNotFoundMiddleware.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 04. 07..
//

import Vapor
import ViewKit

struct FrontendNotFoundMiddleware: Middleware {

    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        return next.respond(to: request)
        .flatMapError { error in
            if let abort = error as? AbortError, abort.status == .notFound {
                return self.notFound(request)
            }
            return request.eventLoop.future(error: error)
        }
    }

    func notFound(_ req: Request) -> EventLoopFuture<Response> {
        let title = req.variables.get("page.not.found.title")
        let excerpt = req.variables.get("page.not.found.description")
        let head = HeadContext(title: title, excerpt: excerpt, indexed: false)
        return req.view.render("Frontend/NotFound", HTMLContext(head, ""))
            .flatMap { $0.encodeResponse(status: .notFound, for: req) }
    }
}
