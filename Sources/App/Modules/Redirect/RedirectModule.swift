//
//  RedirectModule.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 25..
//

import FeatherCore

final class RedirectModule: ViperModule {

    static let name = "redirect"
    var priority: Int { 2000 }

    var router: ViperRouter? = RedirectRouter()

    var migrations: [Migration] {
        [
            RedirectMigration_v1_0_0(),
        ]
    }

    static var bundleUrl: URL? {
        URL(fileURLWithPath: Application.Paths.base)
            .appendingPathComponent("Sources")
            .appendingPathComponent("App")
            .appendingPathComponent("Modules")
            .appendingPathComponent("Redirect")
            .appendingPathComponent("Bundle")
    }
   
    func boot(_ app: Application) throws {
        app.hooks.register("admin", use: (router as! RedirectRouter).adminRoutesHook)
        app.hooks.register("frontend-page", use: frontendPageHook)
        app.hooks.register("leaf-admin-menu", use: leafAdminMenuHook)
    }

    // MARK: - hooks

    func leafAdminMenuHook(args: HookArguments) -> LeafDataRepresentable {
        [
            "name": "Redirect",
            "icon": "arrow-right",
            "items": LeafData.array([
                [
                    "url": "/admin/redirect/redirects/",
                    "label": "Redirects",
                ],
            ])
        ]
    }

    func frontendPageHook(args: HookArguments) -> EventLoopFuture<Response?>? {
        let req = args["req"] as! Request
        return RedirectModel
            .query(on: req.db)
            .filter(\.$source == req.url.path)
            .first()
            .map {
                guard let model = $0 else {
                    return nil
                }
                return req.redirect(to: model.destination, type: model.type)
            }
    }
}
