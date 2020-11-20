//
//  MenuModule.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

import Vapor
import Fluent
import ViperKit

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

    var viewsUrl: URL? {
        nil
//        Bundle.module.bundleURL
//            .appendingPathComponent("Contents")
//            .appendingPathComponent("Resources")
//            .appendingPathComponent("Views")
    }
    
    // MARK: - hook functions
    
    func invoke(name: String, req: Request, params: [String : Any]) -> EventLoopFuture<Any?>? {
        switch name {
        case "prepare-menus":
            return prepareMenus(req: req, params: params).erase()
        default:
            return nil
        }
    }

    func invokeSync(name: String, req: Request?, params: [String : Any]) -> Any? {
        switch name {
        case "installer":
            return MenuInstaller()
        case "leaf-admin-menu":
            return [
                "name": "Menu",
                "icon": "compass",
                "items": LeafData.array([
                    [
                        "url": "/admin/menu/menus/",
                        "label": "Menus",
                    ],
                ])
            ]
        default:
            return nil
        }
    }
    
    // MARK: - private
    
    private func prepareMenus(req: Request, params: [String: Any]) -> EventLoopFuture<[String:LeafDataRepresentable]> {
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
