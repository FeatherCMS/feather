import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct DeviceVendor: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogDeviceVendorField" }
        var example: String? = "Apple"
    }
}
