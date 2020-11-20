//
//  RedirectModule.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 25..
//

import Vapor
import Fluent
import ViperKit

final class RedirectModule: ViperModule {

    static let name = "redirect"
    var priority: Int { 900 }

    var router: ViperRouter? = RedirectRouter()

    var migrations: [Migration] {
        [
            RedirectMigration_v1_0_0(),
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
        default:
            return nil
        }
    }
    
    func invokeSync(name: String, req: Request?, params: [String : Any]) -> Any? {
        switch name {
        case "leaf-admin-menu":
            return [
                "name": "Redirect",
                "icon": "arrow-right",
                "items": LeafData.array([
                    [
                        "url": "/admin/redirect/redirects/",
                        "label": "Redirects",
                    ],
                ])
            ]
        default:
            return nil
        }
    }

    private func frontendPageHook(req: Request) -> EventLoopFuture<Any?>? {
        RedirectModel
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
