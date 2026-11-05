import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct DeviceType: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogDeviceTypeField" }
        var example: String? = "desktop"
    }
}
