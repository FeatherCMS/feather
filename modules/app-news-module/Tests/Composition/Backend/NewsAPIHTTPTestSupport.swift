import FeatherDBALTesting
import FeatherDatabase
import FeatherDatabaseTesting
import FeatherHTTP
import FeatherHTTPHummingbirdTesting
import FeatherInfrastructure
import FeatherModuleKit
import FeatherTesting
import Foundation
import Hummingbird
import HummingbirdTesting
import NewsAdminAPI
import NewsBackend
import NewsModule
import OpenAPIHummingbird
import Testing

enum NewsQueryKey: DatabaseQueryKey {
    case articleSearch
    case articleCount
}

enum NewsAPIHTTPTestSupport {
    struct Context {
        let executor: HummingbirdTestingHTTPExecutor
        let connection: MockDatabaseConnection<NewsQueryKey>
    }

    static func makeContext() throws -> Context {
        let connection = MockDatabaseConnection<NewsQueryKey>(
            responses: [
                .init(key: .articleSearch, rows: [articleRow()]),
                .init(key: .articleCount, rows: [.init(["count": .int(1)])]),
            ]
        )
        let databaseContext = DatabaseClientContext(
            database: FeatherTesting.DatabaseClient.Mock(
                connection: connection
            ),
            idGenerator: FeatherTesting.IDGenerator.Mock(id: "created-1"),
            platform: MockDatabasePlatform()
        )
        let gateway = AdminAPIGateway(
            useCases: UseCases(
                databaseContext: databaseContext,
                authorizer: FeatherTesting.Authorizer.Mock(result: true)
            )
        )
        let router = Router()
        try gateway.registerHandlers(on: router)
        return Context(
            executor: HummingbirdTestingHTTPExecutor(
                app: Application(router: router),
                testingSetup: .router
            ),
            connection: connection
        )
    }

    static func send(
        _ request: some RequestRepresentable,
        using executor: HummingbirdTestingHTTPExecutor
    ) async throws -> String {
        try await CurrentSubject.set(subject: Subject(id: "admin-1")) {
            try await executor.withOperation(request: request) { response in
                #expect(response.status.code == 200)
                return try await response.plainTextBody()
            }
        }
    }

    private static func articleRow() -> MockDatabaseRow {
        let timestamp = Date(timeIntervalSince1970: 1_700_000_000)
        return .init([
            "id": .string("article-1"),
            "title": .string("Swift release"),
            "excerpt": .string("A short update"),
            "content": .string("Release details"),
            "image_asset_id": .null,
            "created_at": .date(timestamp),
            "updated_at": .date(timestamp),
        ])
    }
}
