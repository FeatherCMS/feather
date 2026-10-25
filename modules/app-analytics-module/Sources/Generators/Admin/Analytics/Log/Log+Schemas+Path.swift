import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct Path: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogPathField" }
        var example: String? = "/articles/hello-world/"
    }
}
