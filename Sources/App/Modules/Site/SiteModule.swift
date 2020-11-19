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

    func invokeSync(name: String, req: Request?, params: [String : Any]) -> Any? {
        switch name {
        case "frontend-middlwares":
            return [AnalyticsMiddleware()]
        case "leaf-admin-menu":
            return [
                "name": "Site",
                "icon": "star",
                "items": LeafData.array([
                    [
                        "url": "/admin/site/settings/",
                        "label": "Settings",
                    ],
                ])
            ]
        default:
            return nil
        }
    }

}
