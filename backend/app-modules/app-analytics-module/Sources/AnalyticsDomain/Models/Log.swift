import Domain
import struct Foundation.Date

public struct Log: Model {

    public enum Source: String, Sendable, CaseIterable {
        case backendAPI = "backend_api"
        case webApp = "web_app"
    }

    public enum Error: DomainError {
        case methodTooShort
        case methodTooLong
        case urlTooShort
        case urlTooLong
        case pathTooShort
        case pathTooLong
        case invalidResponseCode
    }

    public struct New: Sendable {
        public let id: String
        public let accountId: String?
        public let source: Source
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
    }

    public let id: String
    public let accountId: String?
    public let source: Source
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
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        accountId: String?,
        source: Source,
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
        createdAt: Date,
        updatedAt: Date
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

public extension Log {

    private static func validate(
        method: String
    ) throws(Self.Error) {
        guard !method.isEmpty else {
            throw .methodTooShort
        }
        guard method.count < 32 else {
            throw .methodTooLong
        }
    }

    private static func validate(
        url: String
    ) throws(Self.Error) {
        guard !url.isEmpty else {
            throw .urlTooShort
        }
        guard url.count < 2048 else {
            throw .urlTooLong
        }
    }

    private static func validate(
        path: String
    ) throws(Self.Error) {
        guard !path.isEmpty else {
            throw .pathTooShort
        }
        guard path.count < 1024 else {
            throw .pathTooLong
        }
    }

    private static func validate(
        responseCode: Int
    ) throws(Self.Error) {
        guard (100...599).contains(responseCode) else {
            throw .invalidResponseCode
        }
    }

    static func create(
        id: String,
        accountId: String?,
        source: Source,
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
        responseCode: Int
    ) throws(Self.Error) -> Self.New {
        try validate(method: method)
        try validate(url: url)
        try validate(path: path)
        try validate(responseCode: responseCode)

        return .init(
            id: id,
            accountId: accountId,
            source: source,
            method: method,
            url: url,
            headers: headers,
            ip: ip,
            path: path,
            referer: referer,
            origin: origin,
            acceptLanguage: acceptLanguage,
            userAgent: userAgent,
            language: language,
            region: region,
            osName: osName,
            osVersion: osVersion,
            browserName: browserName,
            browserVersion: browserVersion,
            engineName: engineName,
            engineVersion: engineVersion,
            deviceVendor: deviceVendor,
            deviceType: deviceType,
            deviceModel: deviceModel,
            cpu: cpu,
            responseCode: responseCode
        )
    }
}
