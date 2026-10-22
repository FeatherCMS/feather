import AccountAdminAPI
import AccountBackend
import AccountModule
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
import Hummingbird
import HummingbirdTesting
import OpenAPIHummingbird
import OpenAPIRuntime
import Testing

enum AccountAPIHTTPTestSupport {
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
                authorizer: FeatherTesting.Authorizer.Mock(result: true),
                jobs: NoOpSendMailJobController(),
                events: EventRegistry()
            )
        )
        let router = Router()
        router.addMiddleware { HTTPErrorStatusMiddleware() }
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

private struct NoOpSendMailJobController: SendMailJobController {
    func enqueue(_ mail: Mail) async throws {}
}

private struct HTTPErrorStatusMiddleware: RouterMiddleware {
    func handle(
        _ request: Request,
        context: BasicRequestContext,
        next:
            @concurrent (Request, BasicRequestContext) async throws -> Response
    ) async throws -> Response {
        do {
            return try await next(request, context)
        }
        catch let error as HTTPError {
            return Response(status: error.status)
        }
        catch let error as OpenAPIRuntime.ServerError {
            guard let httpError = error.underlyingError as? HTTPError else {
                throw error
            }
            return Response(status: httpError.status)
        }
    }
}
