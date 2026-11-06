import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct DeviceModel: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogDeviceModelField" }
        var example: String? = "Mac"
    }
}
