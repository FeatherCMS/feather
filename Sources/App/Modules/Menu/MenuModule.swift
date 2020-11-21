//
//  MenuModule.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

import FeatherCore

final class MenuModule: ViperModule {

    static let name = "menu"

    var router: ViperRouter? = MenuRouter()

    var migrations: [Migration] {
        [
            MenuMigration_v1_0_0(),
        ]
    }
    
    var middlewares: [Middleware] {
        [
            PublicMenusMiddleware(),
        ]
    }

    static var bundleUrl: URL? {
        URL(fileURLWithPath: Application.Paths.base)
            .appendingPathComponent("Sources")
            .appendingPathComponent("App")
            .appendingPathComponent("Modules")
            .appendingPathComponent("Menu")
            .appendingPathComponent("Bundle")
    }

    // NOTE: this is a core dependency -> FeatherCore?
    func leafDataGenerator(for req: Request) -> [String: LeafDataGenerator]? {
        req.menus.all.mapValues { .lazy(LeafData($0)) }
    }

    func boot(_ app: Application) throws {
        app.hooks.register("admin", use: (router as! MenuRouter).adminRoutesHook)
        app.hooks.register("installer", use: installerHook)
        app.hooks.register("prepare-menus", use: prepareMenusHook)
        app.hooks.register("leaf-admin-menu", use: leafAdminMenuHook)
    }

    // MARK: - hooks

    func leafAdminMenuHook(args: HookArguments) -> LeafDataRepresentable {
        [
            "name": "Menu",
            "icon": "compass",
            "items": LeafData.array([
                [
                    "url": "/admin/menu/menus/",
                    "label": "Menus",
                ],
            ])
        ]
    }
    
    func installerHook(args: HookArguments) -> ViperInstaller {
        MenuInstaller()
    }
    
    func prepareMenusHook(args: HookArguments) -> EventLoopFuture<[String:LeafDataRepresentable]> {
        let req = args["req"] as! Request
        return MenuModel.query(on: req.db).with(\.$items).all()
        .map { menus in
            var items: [String: LeafDataRepresentable] = [:]
            for menu in menus {
                items[menu.handle] = menu.leafData
            }
            return items
        }
    }

}
