//
//  AnalyticsApplication+UseCases+Tests.swift
//  app-analytics-module
//
//  Created by Binary Birds on 2026. 07. 16.

import AnalyticsDomain
import AnalyticsModule
import FeatherApplication
import FeatherModuleKit
import FeatherTesting
import Foundation
import Testing

@testable import AnalyticsApplication

@Suite
struct AnalyticsApplicationUseCasesTests {
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

    @Test
    func detailLogSuccess() async throws {
        let query = Log.Detail.Query.Mock(result: .init(
            id: "log-detail",
            accountId: nil,
            source: "web_app",
            method: "GET",
            url: "/page",
            headers: "{}",
            ip: nil,
            path: "/page",
            referer: nil,
            origin: nil,
            acceptLanguage: nil,
            userAgent: nil,
            language: nil,
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
            responseCode: 200,
            createdAt: 1,
            updatedAt: 2
        ))
        let queryExecutor = FeatherTesting.QueryExecutor.Mock(
            context: Log.Detail.Scope(query: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = Log.Detail.UseCase(
            authorizer: authorizer,
            query: queryExecutor
        )

        let output = try await useCase.execute(
            subject: Subject(id: "subject-detail"),
            input: .init(id: "log-detail")
        )

        #expect(output.id == "log-detail")
        #expect(output.responseCode == 200)
        #expect(await query.lastID == "log-detail")
        #expect(await queryExecutor.runCallCount == 1)
        #expect(await authorizer.canCallCount == 1)
    }

    @Test
    func detailLogForbiddenDoesNotRunQuery() async throws {
        let query = Log.Detail.Query.Mock()
        let queryExecutor = FeatherTesting.QueryExecutor.Mock(
            context: Log.Detail.Scope(query: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: false)
        let useCase = Log.Detail.UseCase(
            authorizer: authorizer,
            query: queryExecutor
        )

        await #expect(throws: AuthError.self) {
            try await useCase.execute(
                subject: Subject(id: "subject-denied"),
                input: .init(id: "log-denied")
            )
        }

        #expect(await authorizer.canCallCount == 1)
        #expect(await query.findCallCount == 0)
        #expect(await queryExecutor.runCallCount == 0)
    }

    @Test
    func listLogsAndCountSuccess() async throws {
        let queryInput = Log.List.Input.Query(search: "checkout")
        let query = Log.List.Query.Mock(
            result: .init(items: []),
            countResult: 7
        )
        let queryExecutor = FeatherTesting.QueryExecutor.Mock(
            context: Log.List.Scope(query: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = Log.List.UseCase(
            authorizer: authorizer,
            query: queryExecutor
        )

        let output = try await useCase.execute(
            subject: Subject(id: "subject-list"),
            input: .init(query: queryInput)
        )
        let count = try await useCase.count(
            subject: Subject(id: "subject-list"),
            input: .init(query: queryInput)
        )

        #expect(output.items.isEmpty)
        #expect(count == 7)
        #expect(await query.lastListQuery?.search == "checkout")
        #expect(await query.lastCountQuery?.search == "checkout")
        #expect(await queryExecutor.runCallCount == 2)
        #expect(await authorizer.canCallCount == 2)
    }

    @Test
    func listLogsForbiddenDoesNotRunQueries() async throws {
        let query = Log.List.Query.Mock()
        let queryExecutor = FeatherTesting.QueryExecutor.Mock(
            context: Log.List.Scope(query: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: false)
        let useCase = Log.List.UseCase(
            authorizer: authorizer,
            query: queryExecutor
        )
        let input = Log.List.Input(query: .init())

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-denied"),
                input: input
            )
        }
        await #expect(throws: AuthError.self) {
            _ = try await useCase.count(
                subject: Subject(id: "subject-denied"),
                input: input
            )
        }

        #expect(await authorizer.canCallCount == 2)
        #expect(await query.listCallCount == 0)
        #expect(await query.countCallCount == 0)
        #expect(await queryExecutor.runCallCount == 0)
    }

    @Test
    func searchLogsSuccess() async throws {
        let query = Log.Search.Query.Mock(
            result: .init(items: [], total: 13)
        )
        let queryExecutor = FeatherTesting.QueryExecutor.Mock(
            context: Log.Search.Scope(log: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = Log.Search.UseCase(
            authorizer: authorizer,
            query: queryExecutor
        )

        let output = try await useCase.execute(
            subject: Subject(id: "subject-search"),
            input: .init(query: .init(search: "/api"))
        )

        #expect(output.items.isEmpty)
        #expect(output.total == 13)
        #expect(await query.lastQuery?.search == "/api")
        #expect(await authorizer.canCallCount == 1)
        #expect(await queryExecutor.runCallCount == 1)
    }

    @Test
    func searchLogsForbiddenDoesNotRunQuery() async throws {
        let query = Log.Search.Query.Mock()
        let queryExecutor = FeatherTesting.QueryExecutor.Mock(
            context: Log.Search.Scope(log: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: false)
        let useCase = Log.Search.UseCase(
            authorizer: authorizer,
            query: queryExecutor
        )

        await #expect(throws: AuthError.self) {
            try await useCase.execute(
                subject: Subject(id: "subject-denied"),
                input: .init(query: .init())
            )
        }

        #expect(await authorizer.canCallCount == 1)
        #expect(await query.searchCallCount == 0)
        #expect(await queryExecutor.runCallCount == 0)
    }

    @Test
    func overviewLogsSuccess() async throws {
        let output = Log.Overview.Output(
            kpis: .init(
                totalRequests: 1,
                averageRequestsPerDay: 1,
                authenticatedRequests: 1,
                notFoundRequests: 1,
                clientErrorRequests: 1,
                serverErrorRequests: 1,
                pageViews: 1,
                searchRequests: 1,
                botRequests: 1,
                aiRequests: 1,
                humanRequests: 1,
                uniqueVisitors: 1
            ),
            daily: [],
            statusFamilies: [],
            methods: [],
            paths: [],
            notFoundPaths: [],
            serverErrorPaths: [],
            referrers: [],
            browsers: [],
            operatingSystems: [],
            deviceTypes: [],
            languages: [],
            regions: []
        )
        let query = Log.Overview.Query.Mock(result: output)
        let queryExecutor = FeatherTesting.QueryExecutor.Mock(
            context: Log.Overview.Scope(query: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = Log.Overview.UseCase(
            authorizer: authorizer,
            query: queryExecutor
        )
        let input = Log.Overview.Input(
            query: .init(source: "web_app", from: 1, to: 2)
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-overview"),
            input: input
        )

        #expect(result.kpis.totalRequests == 1)
        #expect(await query.lastQuery?.source == "web_app")
        #expect(await query.lastQuery?.from == 1)
        #expect(await query.lastQuery?.to == 2)
        #expect(await authorizer.canCallCount == 1)
        #expect(await queryExecutor.runCallCount == 1)
    }

    @Test
    func overviewLogsForbiddenDoesNotRunQuery() async throws {
        let query = Log.Overview.Query.Mock()
        let queryExecutor = FeatherTesting.QueryExecutor.Mock(
            context: Log.Overview.Scope(query: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: false)
        let useCase = Log.Overview.UseCase(
            authorizer: authorizer,
            query: queryExecutor
        )

        await #expect(throws: AuthError.self) {
            try await useCase.execute(
                subject: Subject(id: "subject-denied"),
                input: .init(query: .init(source: "web_app", from: 1, to: 2))
            )
        }

        #expect(await authorizer.canCallCount == 1)
        #expect(await query.overviewCallCount == 0)
        #expect(await queryExecutor.runCallCount == 0)
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
