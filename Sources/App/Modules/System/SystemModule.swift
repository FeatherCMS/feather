//
//  SystemModule.swift
//  Feather
//
//  Created by Tibor Bödecs on 2020. 06. 10..
//

import Vapor
import Fluent
import ViperKit
import FeatherCore

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
            RequestVariablesMiddleware()
        ]
    }

//    var tags: [ViperLeafFunction] = [
//        SystemVariableTag()
//    ]
    
    var viewsUrl: URL? {
        nil
//        Bundle.module.bundleURL
//            .appendingPathComponent("Contents")
//            .appendingPathComponent("Resources")
//            .appendingPathComponent("Views")
    }
    
    // MARK: - hook functions

    func invoke(name: String, req: Request, params: [String : Any] = [:]) -> EventLoopFuture<Any?>? {
        
        switch name {
        case "frontend-page":
            return frontendPageHook(req: req)
        case "install":
            return installHook(req: req)
        case "prepare-variables":
            return prepareVariables(req: req, params: params).erase()
        case "set-variable":
            return setVariable(req: req, params: params).erase()
        case "unset-variable":
            return unsetVariable(req: req, params: params).erase()

        default:
            return nil
        }
    }
    
    private func prepareVariables(req: Request, params: [String: Any]) -> EventLoopFuture<[String:String]> {
        return SystemVariableModel.query(on: req.db).all()
        .map { variables in
            var items: [String: String] = [:]
            for variable in variables {
                items[variable.key] = variable.value
                //req.variables.cache.storage[variable.key] = variable.value
            }
            return items
        }
    }
    
    private func setVariable(req: Request, params: [String: Any]) -> EventLoopFuture<Bool> {
        guard
            let key = params["key"] as? String,
            let value = params["value"] as? String
        else {
            return req.eventLoop.future(false)
        }
        
        let hidden = params["hidden"] as? Bool
        let notes = params["notes"] as? String

        return SystemVariableModel
            .query(on: req.db)
            .filter(\.$key == key)
            .first()
            .flatMap { model -> EventLoopFuture<Bool> in
                if let model = model {
                    model.value = value
                    if let hidden = hidden {
                        model.hidden = hidden
                    }
                    model.notes = notes
                    return model.update(on: req.db).map { true }
                }
                return SystemVariableModel(key: key,
                                           value: value,
                                           hidden: hidden ?? false,
                                           notes: notes)
                    .create(on: req.db)
                    .map { true }
            }
    }
    
    private func unsetVariable(req: Request, params: [String: Any]) -> EventLoopFuture<Bool> {
        guard let key = params["key"] as? String else {
            return req.eventLoop.future(false)
        }
        return SystemVariableModel
            .query(on: req.db)
            .filter(\.$key == key)
            .delete()
            .map { true }
    }

    private func installHook(req: Request) -> EventLoopFuture<Any?>? {
        req.eventLoop.flatten([
            req.variables.set("site.title", value: "Feather"),
            req.variables.set("site.excerpt", value: "Welcome to Feather CMS"),
            
            req.variables.set("home.page.title", value: "Home page title"),
            req.variables.set("home.page.description", value: "Home page description"),
            
            req.variables.set("page.not.found.icon", value: "🙉"),
            req.variables.set("page.not.found.title", value: "Page not found"),
            req.variables.set("page.not.found.description", value: "This page is not available anymore."),
            req.variables.set("page.not.found.link", value: "Go to the home page →"),
            
            req.variables.set("empty.list.icon", value: "🔍"),
            req.variables.set("empty.list.title", value: "Empty list"),
            req.variables.set("empty.list.description", value: "Unfortunately there are no results."),
            req.variables.set("empty.list.link", value: "Try again from scratch →"),
        ])
        .map { $0 as Any }
    }

    private func frontendPageHook(req: Request) -> EventLoopFuture<Any?>? {
        if req.variables.get("system.installed") == "true" {
            return nil
        }

        return req.hookAll("install", type: Void.self)
        .flatMap { _ in req.variables.set("system.installed", value: "true", hidden: true) }
        .map { _ -> Response? in req.redirect(to: "/") }
        .map { $0 as Any }
    }
}
