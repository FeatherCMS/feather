import AnalyticsDomain
import FeatherDatabase
import Infrastructure

extension LogTable.Row {
    var asDomain: Log {
        .init(
            id: id,
            accountId: accountId,
            source: .init(rawValue: source) ?? .backendAPI,
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
            responseCode: responseCode,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseLogRepository: LogRepository {

    public let connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func insert(
        _ model: Log.New
    ) async throws -> Log {
        let table = LogTable(connection: connection)
        let saved = try await table.create(
            row: .init(
                id: model.id,
                accountId: model.accountId,
                source: model.source.rawValue,
                method: model.method,
                url: model.url,
                headers: model.headers,
                ip: model.ip,
                path: model.path,
                referer: model.referer,
                origin: model.origin,
                acceptLanguage: model.acceptLanguage,
                userAgent: model.userAgent,
                language: model.language,
                region: model.region,
                osName: model.osName,
                osVersion: model.osVersion,
                browserName: model.browserName,
                browserVersion: model.browserVersion,
                engineName: model.engineName,
                engineVersion: model.engineVersion,
                deviceVendor: model.deviceVendor,
                deviceType: model.deviceType,
                deviceModel: model.deviceModel,
                cpu: model.cpu,
                responseCode: model.responseCode
            )
        )
        return saved.asDomain
    }
}
