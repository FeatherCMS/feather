//
//  Log+Repository+Database.swift
//  app-analytics-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import AnalyticsDomain
public import AnalyticsModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure

extension Log.Table.Detail {
    var asDomain: Log.Model {
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
            trafficCategory: Log.Model.TrafficCategory(
                rawValue: trafficCategory
            ) ?? .human,
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

extension Log.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext

        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func insert(
            _ model: Log.Model.New
        ) async throws -> Log.Model {
            let accessLayer = DatabaseAccessLayer<Log.Table>(context: context)
            let row = Log.Table.Insert(
                id: context.idGenerator.generate(),
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
                trafficCategory: model.trafficCategory.rawValue,
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
            try await accessLayer.insert(row)
            guard
                let saved = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: row.id
                )
            else {
                throw RepositoryError.notFound
            }
            return saved.asDomain
        }
    }
}
