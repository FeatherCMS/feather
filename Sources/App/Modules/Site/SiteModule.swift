//
//  SiteModule.swift
//  Site
//
//  Created by Tibor Bödecs on 2020. 11. 19..
//

import FeatherCore

final class SiteModule: ViperModule {

    static var name: String = "site"

    var router: ViperRouter? { SiteRouter() }

    static var bundleUrl: URL? {
        URL(fileURLWithPath: Application.Paths.base)
            .appendingPathComponent("Sources")
            .appendingPathComponent("App")
            .appendingPathComponent("Modules")
            .appendingPathComponent("Site")
            .appendingPathComponent("Bundle")
    }
    
    func boot(_ app: Application) throws {
        app.hooks.register("admin", use: (router as! SiteRouter).adminRoutesHook)
        app.hooks.register("leaf-admin-menu", use: leafAdminMenuHook)
    }

    // MARK: - hooks

    func leafAdminMenuHook(args: HookArguments) -> LeafDataRepresentable {
        [
            "name": "Site",
            "icon": "star",
            "items": LeafData.array([
                [
                    "url": "/admin/site/settings/",
                    "label": "Settings",
                ],
            ])
        ]
    }
}
