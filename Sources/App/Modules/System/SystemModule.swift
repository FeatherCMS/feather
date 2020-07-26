//
//  SystemModule.swift
//  FeatherCMS
//
//  Created by Tibor Bödecs on 2020. 06. 10..
//

import Vapor
import Fluent
import ViperKit

final class SystemModule: ViperModule {

    static var name: String = "system"
    var priority: Int { 1 }

    var router: ViperRouter? { SystemRouter() }

    var migrations: [Migration] {
        [
            SystemMigration_v1_0_0(),
        ]
    }
    
    var middlewares: [Middleware] {
        [
            SystemVariableMiddleware()
        ]
    }

    var tags: [ViperLeafTag] = [
        SystemVariableTag()
    ]
    
    // MARK: - hook functions

    func invoke(name: String, req: Request, params: [String : Any] = [:]) -> EventLoopFuture<Any?>? {
        
        switch name {
        case "frontend-page":
            return self.frontendPageHook(req: req)
        case "install":
            return self.installHook(req: req)
        default:
            return nil
        }
    }

    private func installHook(req: Request) -> EventLoopFuture<Any?>? {
        req.eventLoop.flatten([
            req.variables.set("page.not.found.icon", value: "🙉"),
            req.variables.set("page.not.found.title", value: "Page not found"),
            req.variables.set("page.not.found.description", value: "This page is not available anymore."),
            req.variables.set("page.not.found.link", value: "Go to the home page →"),
            req.variables.set("site.title", value: "Feather"),
            req.variables.set("site.excerpt", value: "Welcome to Feather CMS"),
            req.variables.set("home.page.title", value: "Home page title"),
            req.variables.set("home.page.description", value: "Home page description"),
        ])
        .map { $0 as Any }
    }

    private func frontendPageHook(req: Request) -> EventLoopFuture<Any?>? {
        if req.variables.get("system.installed") == "true" {
            return nil
        }
        return req.application.viper.invokeAllHooks(name: "install", req: req, type: Void.self)
        .flatMap { _ in req.variables.set("system.installed", value: "true", hidden: true) }
        .map { _ -> Response? in req.redirect(to: "/") }
        .map { $0 as Any }
    }
}
