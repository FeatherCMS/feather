import AnalyticsDomain
public import FeatherApplication

extension Log.Track {
    public struct Input: DTO {
        public let accountId: String?
        public let source: Log.Source
        public let method: String
        public let url: String
        public let headers: String
        public let ip: String?
        public let path: String
        public let referer: String?
        public let origin: String?
        public let acceptLanguage: String?
        public let userAgent: String?
        public let trafficCategory: Log.TrafficCategory
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

        public init(
            accountId: String?,
            source: Log.Source,
            method: String,
            url: String,
            headers: String,
            ip: String?,
            path: String,
            referer: String?,
            origin: String?,
            acceptLanguage: String?,
            userAgent: String?,
            trafficCategory: Log.TrafficCategory = .human,
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
            responseCode: Int
        ) {
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
            self.trafficCategory = trafficCategory
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
        }
    }
}
