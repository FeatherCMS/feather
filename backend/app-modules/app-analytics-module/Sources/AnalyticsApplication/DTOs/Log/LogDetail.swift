import Application

public struct LogDetail: DTO {
    public let id: String
    public let accountId: String?
    public let source: String
    public let method: String
    public let url: String
    public let headers: String
    public let ip: String?
    public let path: String
    public let referer: String?
    public let origin: String?
    public let acceptLanguage: String?
    public let userAgent: String?
    public let language: String?
    public let region: String?
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
    public let responseCode: Int
    public let createdAt: Double
    public let updatedAt: Double

    public init(
        id: String,
        accountId: String?,
        source: String,
        method: String,
        url: String,
        headers: String,
        ip: String?,
        path: String,
        referer: String?,
        origin: String?,
        acceptLanguage: String?,
        userAgent: String?,
        language: String?,
        region: String?,
        osName: String?,
        osVersion: String?,
        browserName: String?,
        browserVersion: String?,
        engineName: String?,
        engineVersion: String?,
        deviceVendor: String?,
        deviceType: String?,
        deviceModel: String?,
        cpu: String?,
        responseCode: Int,
        createdAt: Double,
        updatedAt: Double
    ) {
        self.id = id
        self.accountId = accountId
        self.source = source
        self.method = method
        self.url = url
        self.headers = headers
        self.ip = ip
        self.path = path
        self.referer = referer
        self.origin = origin
        self.acceptLanguage = acceptLanguage
        self.userAgent = userAgent
        self.language = language
        self.region = region
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
        self.responseCode = responseCode
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
