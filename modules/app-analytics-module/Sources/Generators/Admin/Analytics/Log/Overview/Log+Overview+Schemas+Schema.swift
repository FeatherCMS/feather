import FeatherOpenAPI

extension Analytics.Log.Overview.Schemas {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogOverviewSchema" }
        var propertyMap: SchemaMap {
            [
                "query": Query().reference(),
                "kpis": KPI().reference(),
                "daily": DailyList().reference(),
                "statusFamilies": BreakdownList().reference(),
                "methods": BreakdownList().reference(),
                "paths": BreakdownList().reference(),
                "notFoundPaths": BreakdownList().reference(),
                "serverErrorPaths": BreakdownList().reference(),
                "referrers": BreakdownList().reference(),
                "browsers": BreakdownList().reference(),
                "operatingSystems": BreakdownList().reference(),
                "deviceTypes": BreakdownList().reference(),
                "languages": BreakdownList().reference(),
                "regions": BreakdownList().reference(),
            ]
        }
    }
}
