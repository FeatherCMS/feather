//
//  Log+Track+UseCase.swift
//  app-analytics-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AnalyticsDomain
public import AnalyticsModule
public import FeatherApplication
public import FeatherModuleKit

extension Log.Track {
    public struct UseCase: FeatherApplication.UseCase {

        let transaction: any TransactionExecutor<WriteLog>

        public init(
            transaction: any TransactionExecutor<WriteLog>
        ) {
            self.transaction = transaction
        }

        public func execute(
            input: Log.Track.Input
        ) async throws -> Log.Track.Output {
            let model = try await transaction.run { scope in
                try await scope.log.insert(
                    Log.Model.create(
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
                        trafficCategory: input.trafficCategory,
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
            return .init(id: model.id)
        }
    }
}
