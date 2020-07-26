//
//  AdminController.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

import Vapor
import Fluent
import ViperKit
import ViewKit

struct AdminController {

    func adminView(req: Request) throws -> EventLoopFuture<Response> {
        guard req.auth.has(UserModel.self) else {
            let redirectPath = "/" + (req.query["redirect"] ?? "login")
            let response = req.redirect(to: redirectPath)
            return req.eventLoop.future(response)
        }
        let user = try req.auth.require(UserModel.self)
        return req.view.render("Admin/Home", ["email": user.email]).encodeResponse(for: req)
    }
}
