import FeatherOpenAPI

extension Analytics.Log.Overview.Schemas {
    struct KPI: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogOverviewKPISchema" }
        var propertyMap: SchemaMap {
            [
                "totalRequests": KPIInt(),
                "averageRequestsPerDay": KPIValue(),
                "authenticatedRequests": KPIInt(),
                "notFoundRequests": KPIInt(),
                "clientErrorRequests": KPIInt(),
                "serverErrorRequests": KPIInt(),
                "pageViews": KPIInt(),
                "searchRequests": KPIInt(),
                "botRequests": KPIInt(),
                "aiRequests": KPIInt(),
                "humanRequests": KPIInt(),
                "uniqueVisitors": KPIInt(),
            ]
        }
    }
}
