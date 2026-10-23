//
//  AnalyticsApplicationTestSuite.swift
//  app-analytics-module
//
//  Created by Binary Birds on 2026. 07. 16.

import AnalyticsDomain
import AnalyticsModule
import FeatherModuleKit
import Foundation
import Testing

@testable import AnalyticsApplication

@Suite
struct AnalyticsApplicationTestSuite {
    @Test
    func trackInsertsLogInsideTransactionAndReturnsCreatedID() async throws {
        let repository = MockLogRepository()
        let transaction = MockTransactionExecutor(
            context: Log.Track.Scope(log: repository)
        )
        let useCase = Log.Track.UseCase(transaction: transaction)
        let input = Log.Track.Input(
            accountId: "account-1",
            source: .webApp,
            method: "POST",
            url: "/forms/contact",
            headers: "{}",
            ip: "127.0.0.1",
            path: "/forms/contact",
            referer: nil,
            origin: nil,
            acceptLanguage: "en",
            userAgent: "test-agent",
            language: "en",
            region: nil,
            osName: nil,
            osVersion: nil,
            browserName: nil,
            browserVersion: nil,
            engineName: nil,
            engineVersion: nil,
            deviceVendor: nil,
            deviceType: nil,
            deviceModel: nil,
            cpu: nil,
            responseCode: 201
        )

        let output = try await useCase.execute(input: input)

        #expect(output.id == "log-1")
        #expect(await transaction.runCallCount == 1)
        let inserted = await repository.insertedModels
        #expect(inserted.count == 1)
        #expect(inserted.first?.path == "/forms/contact")
        #expect(inserted.first?.responseCode == 201)
        #expect(inserted.first?.trafficCategory == .human)
    }
}

private actor MockTransactionExecutor<S: Scope>: TransactionExecutor {
    let context: S
    private(set) var runCallCount = 0

    init(context: S) {
        self.context = context
    }

    func run<T: Sendable>(
        _ body: @Sendable (S) async throws -> T
    ) async throws -> T {
        runCallCount += 1
        return try await body(context)
    }
}

private actor MockLogRepository: Log.Repository.Interface {
    private(set) var insertedModels: [Log.Model.New] = []

    func insert(_ model: Log.Model.New) async throws -> Log.Model {
        insertedModels.append(model)
        let now = Date()
        return .init(
            id: "log-1",
            accountId: model.accountId,
            source: model.source,
            method: model.method,
            url: model.url,
            headers: model.headers,
            ip: model.ip,
            path: model.path,
            referer: model.referer,
            origin: model.origin,
            acceptLanguage: model.acceptLanguage,
            userAgent: model.userAgent,
            trafficCategory: model.trafficCategory,
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
            createdAt: now,
            updatedAt: now
        )
    }
}
