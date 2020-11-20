//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 19..
//

import Fluent
import FeatherCore
import SQLKit

struct AnalyticsOverviewAdminController {

    struct GroupCount: Decodable {
        let name: String
        let count: Int
    }

    struct MetricsGroup: LeafDataRepresentable {
        let icon: String
        let name: String
        let groups: [GroupCount]
        
        var total: Int { groups.reduce(0, { $0 + $1.count }) }
        
        var leafData: LeafData {
            .dictionary([
                "icon": icon,
                "name": name,
                "groups": groups.sorted(by: { $0.count > $1.count })
                    .map { group in LeafData.dictionary([
                        "name": group.name,
                        "count": group.count,
                        "percent": String(format: "%.0f", Double(group.count) / Double(total) * 100),
                    ])},
                "total": total
            ])
        }
    }

    /// This won't work with the MongoDB driver yet, see https://github.com/vapor/fluent-kit/issues/206
    func count(req: Request, icon: String, name: String, groupBy group: String) -> EventLoopFuture<MetricsGroup?>{
        guard let db = req.db as? SQLDatabase else {
            return req.eventLoop.future(nil)
        }
        let sql = "SELECT count(id) AS `count`, `\(group)` AS name FROM analytics_logs GROUP BY `\(group)` ORDER BY count(id) DESC LIMIT 10"
        return db.raw(SQLQueryString(sql)).all(decoding: GroupCount.self).map { MetricsGroup(icon: icon, name: name, groups: $0) }
    }

    func overviewView(req: Request) throws -> EventLoopFuture<View> {
        return req.eventLoop.flatten([
            count(req: req, icon: "compass", name: "Browsers", groupBy: "browser_name"),
            count(req: req, icon: "monitor",  name: "Operating systems", groupBy: "os_name"),
            count(req: req, icon: "message-square",  name: "Languages", groupBy: "language"),
            count(req: req, icon: "anchor",  name: "Pages", groupBy: "path"),
        ])
        .flatMap { metrics in
            let totalPageViews = AnalyticsLogModel.query(on: req.db).count()
            return totalPageViews.flatMap { totalPageViews in
                return req.leaf.render(template: "Analytics/Admin/Overview", context: [
                    "totalPageViews": .int(totalPageViews),
                    "metrics": .array(metrics.compactMap { $0?.leafData }),
                ])
            }
        }
    }
}
