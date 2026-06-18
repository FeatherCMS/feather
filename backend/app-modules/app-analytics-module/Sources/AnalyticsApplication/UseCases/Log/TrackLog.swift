import AnalyticsDomain
import Application
import Domain

public struct TrackLog: UseCase {

    let transaction: any TransactionExecutor<WriteLog>
    let idGenerator: any IDGenerator

    public init(
        transaction: any TransactionExecutor<WriteLog>,
        idGenerator: any IDGenerator
    ) {
        self.transaction = transaction
        self.idGenerator = idGenerator
    }

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

    public func execute(
        input: Input
    ) async throws -> LogList.Item {
        let model = try await transaction.run { context in
            try await context.log.insert(
                Log.create(
                    id: idGenerator.generate(),
                    accountId: input.accountId,
                    source: input.source,
                    method: input.method,
                    url: input.url,
                    headers: input.headers,
                    ip: input.ip,
                    path: input.path,
                    referer: input.referer,
                    origin: input.origin,
                    acceptLanguage: input.acceptLanguage,
                    userAgent: input.userAgent,
                    language: input.language,
                    region: input.region,
                    osName: input.osName,
                    osVersion: input.osVersion,
                    browserName: input.browserName,
                    browserVersion: input.browserVersion,
                    engineName: input.engineName,
                    engineVersion: input.engineVersion,
                    deviceVendor: input.deviceVendor,
                    deviceType: input.deviceType,
                    deviceModel: input.deviceModel,
                    cpu: input.cpu,
                    responseCode: input.responseCode
                )
            )
        }
        return model.asListItem
    }
}
