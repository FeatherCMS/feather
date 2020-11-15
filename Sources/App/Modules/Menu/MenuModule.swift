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

    var viewsUrl: URL? {
        nil
//        Bundle.module.bundleURL
//            .appendingPathComponent("Contents")
//            .appendingPathComponent("Resources")
//            .appendingPathComponent("Views")
    }
    
    // MARK: - hook functions

    func invokeSync(name: String, req: Request?, params: [String : Any]) -> Any? {
        switch name {
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

}
