//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 19..
//

import Fluent
import FeatherCore

struct AnalyticsOverviewAdminController {
    
    func overviewView(req: Request) throws -> EventLoopFuture<View> {
        let totalPageViews = AnalyticsLogModel.query(on: req.db).count()
        return totalPageViews.flatMap { totalPageViews in
            return req.leaf.render(template: "Analytics/Admin/Overview", context: [
                "totalPageViews": .int(totalPageViews),
            ])
        }
    }
}
