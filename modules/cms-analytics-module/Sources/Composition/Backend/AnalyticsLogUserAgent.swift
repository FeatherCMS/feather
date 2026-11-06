public struct AnalyticsLogUserAgent: Sendable {
    public let osName: String?
    public let osVersion: String?
    public let browserName: String?
    public let browserVersion: String?
    public let engineName: String?
    public let engineVersion: String?
    public let deviceVendor: String?
    public let deviceType: String?
    public let deviceModel: String?
    public let cpu: String?

    public init(
        osName: String?,
        osVersion: String?,
        browserName: String?,
        browserVersion: String?,
        engineName: String?,
        engineVersion: String?,
        deviceVendor: String?,
        deviceType: String?,
        deviceModel: String?,
        cpu: String?
    ) {
        self.osName = osName
        self.osVersion = osVersion
        self.browserName = browserName
        self.browserVersion = browserVersion
        self.engineName = engineName
        self.engineVersion = engineVersion
        self.deviceVendor = deviceVendor
        self.deviceType = deviceType
        self.deviceModel = deviceModel
        self.cpu = cpu
    }
}
