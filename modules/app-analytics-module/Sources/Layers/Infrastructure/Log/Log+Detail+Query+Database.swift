public import AnalyticsApplication
import AnalyticsDomain
public import AnalyticsModule
import FeatherDBAL
public import FeatherInfrastructure
import Foundation

extension Log.Detail.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(id: String) async throws -> Log.Detail.Output {
            let accessLayer = DatabaseAccessLayer<Log.Table>(context: context)
            guard
                let row = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else {
                throw RepositoryError.notFound
            }
            let model = row.asDomain
            return .init(
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
                responseCode: model.responseCode,
                createdAt: model.createdAt.timeIntervalSince1970,
                updatedAt: model.updatedAt.timeIntervalSince1970
            )
        }
    }
}
