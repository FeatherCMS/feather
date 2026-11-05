import AnalyticsAdminAPI
import AnalyticsBackend
import AnalyticsModule
import FeatherDBALTesting
import FeatherDatabase
import FeatherDatabaseTesting
import FeatherHTTP
import FeatherHTTPHummingbirdTesting
import FeatherInfrastructure
import FeatherModuleKit
import FeatherTesting
import Hummingbird
import HummingbirdTesting
import OpenAPIHummingbird
import Testing

enum AnalyticsQueryKey: DatabaseQueryKey {
    case search
    case count
}

enum AnalyticsAPIHTTPTestSupport {
    struct Context {
        let executor: HummingbirdTestingHTTPExecutor
        let connection: MockDatabaseConnection<AnalyticsQueryKey>
    }

    static func makeContext() throws -> Context {
        let connection = MockDatabaseConnection<AnalyticsQueryKey>(
            responses: [
                .init(key: .search),
                .init(key: .count, rows: [.init(["count": .int(0)])]),
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
}
