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
import SystemAdminAPI
import SystemBackend
import SystemModule
import Testing

enum SystemAPIHTTPTestSupport {

    static func makeExecutor<Key: DatabaseQueryKey>(
        connection: MockDatabaseConnection<Key>
    ) throws -> HummingbirdTestingHTTPExecutor {
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
        return try makeExecutor(gateway: gateway)
    }

    private static func makeExecutor(
        gateway: AdminAPIGateway
    ) throws -> HummingbirdTestingHTTPExecutor {
        let router = Router()
        try gateway.registerHandlers(on: router)
        return HummingbirdTestingHTTPExecutor(
            app: Application(router: router),
            testingSetup: .router
        )
    }

    static func send(
        _ request: some RequestRepresentable,
        expectedStatus: Int,
        using executor: HummingbirdTestingHTTPExecutor
    ) async throws -> String {
        try await CurrentSubject.set(subject: Subject(id: "admin-1")) {
            try await executor.withOperation(request: request) { response in
                #expect(response.status.code == expectedStatus)
                return try await response.plainTextBody()
            }
        }
    }
}
