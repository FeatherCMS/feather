//
//  AnalyticsModule.swift
//  Analytics
//
//  Created by Tibor Bödecs on 2020. 11. 19..
//

import FeatherCore

final class AnalyticsModule: ViperModule {

    static var name: String = "analytics"

    var router: ViperRouter? { AnalyticsRouter() }

    var middlewares: [Middleware] {
        [
            
        ]
    }
    
    var migrations: [Migration] {
        [
            AnalyticsMigration_v1_0_0(),
        ]
    }

    func invokeSync(name: String, req: Request?, params: [String : Any]) -> Any? {
        switch name {
        case "frontend-middlwares":
            return [AnalyticsMiddleware()]
        case "leaf-admin-menu":
            return [
                "name": "Analytics",
                "icon": "pie-chart",
                "items": LeafData.array([
                    [
                        "url": "/admin/analytics/overview/",
                        "label": "Overview",
                    ],
                    [
                        "url": "/admin/analytics/logs/",
                        "label": "Logs",
                    ],
                ])
            ]
        default:
            return nil
        }
    }


}
