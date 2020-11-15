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
            RequestVariablesMiddleware(),
            SystemInstallGuardMiddleware(),
        ]
    }

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

    func invokeSync(name: String, req: Request?, params: [String : Any]) -> Any? {
        switch name {
        case "installer":
            return SystemInstaller()
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
 
    private func frontendPageHook(req: Request) -> EventLoopFuture<Any?>? {
        if req.variables.get("system.installed") == "true" {
            return nil
        }
        guard req.url.path == "/system/install/" else {
            return req.leaf.render("System/Install/Start").encodeResponse(for: req).erase()
        }
        let assetsPath = Application.Paths.assets

        for module in req.application.viper.modules.map(\.name) {
            let modulePath = Application.Paths.base + "Sources/App/Modules/" + module + "/"
            let installAsssetsPath = modulePath + "Assets/install/"
            let destinationPath = assetsPath + module + "/"

            do {
                try FileManager.default.createDirectory(atPath: Application.Paths.assets,
                                                        withIntermediateDirectories: true,
                                                        attributes: [.posixPermissions: 0o744])
                var isDir : ObjCBool = false
                if FileManager.default.fileExists(atPath: installAsssetsPath, isDirectory: &isDir), isDir.boolValue {
                    try FileManager.default.copyItem(atPath: installAsssetsPath, toPath: destinationPath)
                }
            }
            catch {
                fatalError("Error, please check your Public / assets directories.\n\(error.localizedDescription)")
            }
        }

        /// we gather the system variables, based on the dictionary
        var variables: [SystemVariableModel] = []
        /// we request the install futures for the database model creation
        var modelInstallFutures: [EventLoopFuture<Void>] = []
        
        /// we request the installer objects, then use them to install everything
        let installers = req.syncHookAll("installer", type: ViperInstaller.self)
        for installer in installers {
            let vars = installer.variables().compactMap { dict -> SystemVariableModel? in
                guard
                    let key = dict["key"] as? String, !key.isEmpty,
                    let value = dict["value"] as? String, !value.isEmpty
                else {
                    return nil
                }
                let hidden = dict["hidden"] as? Bool ?? false
                let notes = dict["notes"] as? String
                return SystemVariableModel(key: key, value: value, hidden: hidden, notes: notes)
            }
            variables.append(contentsOf: vars)

            if let future = installer.createModels(req) {
                modelInstallFutures.append(future)
            }
        }
        /// we combine the existing futures and call them
        let futures = [variables.create(on: req.db)] + modelInstallFutures
        return req.eventLoop.flatten(futures)
        .flatMap { _ in req.variables.set("system.installed", value: "true", hidden: true) }
        .flatMap { _ in req.leaf.render("System/Install/Finish") }
        .encodeResponse(for: req)
        .erase()
    }
}
