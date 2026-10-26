import FeatherOpenAPI

extension Analytics.Log.Overview.Schemas {
    struct Query: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogOverviewQuerySchema" }
        var propertyMap: SchemaMap {
            [
                "source": Analytics.Log.Schemas.Source(),
                "from": Date(),
                "to": Date(),
                "dashboardOnly": DashboardOnly()
                    .reference(required: false),
                "notFoundOnly": DashboardOnly()
                    .reference(required: false),
            ]
        }
    }
}
