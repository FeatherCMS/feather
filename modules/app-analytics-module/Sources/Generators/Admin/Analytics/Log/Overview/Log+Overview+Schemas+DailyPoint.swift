import FeatherOpenAPI

extension Analytics.Log.Overview.Schemas {
    struct DailyPoint: ObjectSchemaRepresentable {
        var openAPIIdentifier: String {
            "AnalyticsLogOverviewDailyPointSchema"
        }
        var propertyMap: SchemaMap {
            [
                "bucket": Date(),
                "requests": KPIInt(),
                "notFoundRequests": KPIInt(),
                "clientErrorRequests": KPIInt(),
                "serverErrorRequests": KPIInt(),
            ]
        }
    }
}
