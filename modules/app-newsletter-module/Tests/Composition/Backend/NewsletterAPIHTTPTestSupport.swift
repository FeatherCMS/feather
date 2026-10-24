import FeatherDBALTesting
import FeatherDatabase
import FeatherDatabaseTesting
import FeatherHTTP
import FeatherHTTPHummingbirdTesting
import FeatherInfrastructure
import FeatherMail
import FeatherModuleKit
import FeatherTesting
import Hummingbird
import HummingbirdTesting
import NewsletterAdminAPI
import NewsletterApplication
import NewsletterBackend
import NewsletterModule
import OpenAPIHummingbird
import Testing

import struct Foundation.Date

enum NewsletterAPIQueryKey: DatabaseQueryKey {
    case search
    case count
}

private struct MockIssueJobController: Issue.JobController.Interface
{
    func enqueue(_ mail: Mail) async throws {}

    func enqueueIssue(
        mail: Mail,
        issueId: String,
        newsletterId: String,
        scheduledAt: Date?
    ) async throws {}
}

enum NewsletterAPIHTTPTestSupport {
    struct Context {
        let executor: HummingbirdTestingHTTPExecutor
        let connection: MockDatabaseConnection<NewsletterAPIQueryKey>
    }

    static func makeContext() throws -> Context {
        let connection = MockDatabaseConnection<NewsletterAPIQueryKey>(
            responses: [
                .init(
                    key: .search,
                    rows: [
                        .init([
                            "email": .string("person@example.com"),
                            "first_name": .string("Test"),
                            "last_name": .string("Person"),
                            "campaign_key": .string("weekly"),
                            "campaign_name": .string("Weekly"),
                            "status": .string("subscribed"),
                        ])
                    ]
                ),
                .init(key: .count, rows: [.init(["count": .int(1)])]),
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
                jobs: MockIssueJobController()
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
