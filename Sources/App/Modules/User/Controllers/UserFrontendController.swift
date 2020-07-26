//
//  UserFrontendController.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 03. 27..
//

import Vapor
import Fluent
import ViperKit
import ViewKit

struct UserFrontendController {

    private func render(req: Request, model: UserModel? = nil, form: UserLoginForm = .init()) -> EventLoopFuture<Response> {
        if let model = model {
            form.read(from: model)
        }

        let head = HeadContext(title: "user_login_page_title", excerpt: "user_login_page_description")
        let context = HTMLContext(head, EditContext(form))
        return req.view.render("User/Frontend/Login", context).encodeResponse(for: req)
    }
    
    func loginView(req: Request) throws -> EventLoopFuture<Response> {
        guard req.auth.has(UserModel.self) else {
            return self.render(req: req)
        }
        let redirectPath = "/" + (req.query["redirect"] ?? "admin") + "/"
        let response = req.redirect(to: redirectPath, type: .normal)
        return req.eventLoop.future(response)
    }

    func login(req: Request) throws -> EventLoopFuture<Response> {
        if let user = req.auth.get(UserModel.self) {
            req.session.authenticate(user)
            let redirectPath = "/" + (req.query["redirect"] ?? "admin") + "/"
            let response = req.redirect(to: redirectPath)
            return req.eventLoop.future(response)
        }
        let form = try UserLoginForm(req: req)
        return form.validate(req: req)
        .flatMap { _ in
            form.notification = "Invalid username or password"
            return self.render(req: req, form: form)
        }
    }
    
    func logout(req: Request) throws -> Response {
        req.auth.logout(UserModel.self)
        req.session.unauthenticate(UserModel.self)
        let redirectPath = "/" + (req.query["redirect"] ?? "login") + "/"
        return req.redirect(to: redirectPath)
    }
}
