import ContactAdminAPI
import ContactBackend
import ContactModule
import FeatherApplication
import FeatherDBALTesting
import FeatherDatabase
import FeatherDatabaseTesting
import FeatherHTTP
import FeatherHTTPHummingbirdTesting
import FeatherInfrastructure
import FeatherMail
import FeatherModuleKit
import FeatherTesting
import Foundation
import Hummingbird
import HummingbirdTesting
import OpenAPIHummingbird
import Testing

enum ContactQueryKey: DatabaseQueryKey {
    case formSearch
    case formCount
}

enum ContactAPIHTTPTestSupport {
    struct Context {
        let executor: HummingbirdTestingHTTPExecutor
        let connection: MockDatabaseConnection<ContactQueryKey>
    }

    static func makeContext() throws -> Context {
        let connection = MockDatabaseConnection<ContactQueryKey>(
            responses: [
                .init(key: .formSearch, rows: [formRow()]),
                .init(key: .formCount, rows: [.init(["count": .int(1)])]),
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
                authorizer: FeatherTesting.Authorizer.Mock(result: true),
                jobs: NoOpSendMailJobController(),
                events: EventRegistry()
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

    private static func formRow() -> MockDatabaseRow {
        .init([
            "id": .string("form-1"),
            "key": .string("contact"),
            "name": .string("Contact us"),
            "success_message": .string("Thanks"),
            "failure_message": .string("Try again"),
            "redirect_url": .null,
            "created_at": .date(Date(timeIntervalSince1970: 1_700_000_000)),
            "updated_at": .date(Date(timeIntervalSince1970: 1_700_000_000)),
        ])
    }
}

private struct NoOpSendMailJobController: SendMailJobController {
    func enqueue(_ mail: Mail) async throws {}
}
