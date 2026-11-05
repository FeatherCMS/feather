import FeatherOpenAPI

extension Analytics.Log.Overview.Schemas {
    struct BreakdownItem: ObjectSchemaRepresentable {
        var openAPIIdentifier: String {
            "AnalyticsLogOverviewBreakdownItemSchema"
        }
        var propertyMap: SchemaMap {
            [
                "label": Analytics.Log.Schemas.Search(),
                "count": KPIInt(),
                "share": KPIValue(),
            ]
        }
    }
}
