import FeatherApplication
import FeatherDBALTesting
import FeatherDatabase
import FeatherDatabaseTesting
import FeatherDomain
import FeatherHTTP
import FeatherHTTPHummingbirdTesting
import FeatherInfrastructure
import FeatherModuleKit
import FeatherStorage
import FeatherTesting
import Foundation
import Hummingbird
import HummingbirdTesting
import MediaAdminAPI
import MediaApplication
import MediaBackend
import MediaModule
import OpenAPIHummingbird
import OpenAPIRuntime
import Testing

enum MediaAPIHTTPTestSupport {
    static func makeExecutor<Key: DatabaseQueryKey>(
        connection: MockDatabaseConnection<Key>
    ) throws -> HummingbirdTestingHTTPExecutor {
        let databaseContext = DatabaseClientContext(
            database: FeatherTesting.DatabaseClient.Mock(
                connection: connection
            ),
            idGenerator: FeatherTesting.IDGenerator.Mock(id: "media-test-id"),
            platform: MockDatabasePlatform()
        )
        let storageContext = StorageClientContext(
            storage: UnusedStorageClient(),
            objectKeyGenerator: TestObjectKeyGenerator()
        )
        let gateway = AdminAPIGateway(
            useCases: UseCases(
                databaseContext: databaseContext,
                storageContext: storageContext,
                authorizer: FeatherTesting.Authorizer.Mock(result: true),
                jobs: UnusedJobController()
            ),
            mediaResolver: .init(
                mediaBaseURL: URL(string: "https://media.test")!
            )
        )
        let router = Router()
        router.addMiddleware { MediaHTTPErrorStatusMiddleware() }
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
        try await CurrentSubject.set(subject: Subject(id: "media-admin")) {
            try await executor.withOperation(request: request) { response in
                #expect(response.status.code == expectedStatus)
                return try await response.plainTextBody()
            }
        }
    }
}

private struct MediaHTTPErrorStatusMiddleware: RouterMiddleware {
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

private struct TestObjectKeyGenerator: ObjectKeyGenerator {
    func generate(from value: String) throws -> String { value }
}

private struct UnusedJobController: Asset.File.GenerateVariant.JobController
        .Interface
{
    func enqueue(assetId: String) async throws {}
}

private struct UnusedStorageClient: StorageClient {
    func upload(key: String, sequence: StorageSequence, contentType: String?)
        async throws(StorageClientError)
    {}
    func download(key: String, range: ClosedRange<Int>?)
        async throws(StorageClientError) -> StorageSequence
    { throw .invalidKey }
    func exists(key: String) async throws(StorageClientError) -> Bool { false }
    func size(key: String) async throws(StorageClientError) -> UInt64 { 0 }
    func copy(key source: String, to destination: String)
        async throws(StorageClientError)
    {}
    func list(key: String?) async throws(StorageClientError) -> [String] { [] }
    func delete(key: String) async throws(StorageClientError) {}
    func create(key: String) async throws(StorageClientError) {}
    func createMultipartId(key: String, contentType: String?)
        async throws(StorageClientError) -> String
    { throw .invalidKey }
    func upload(
        multipartId: String,
        key: String,
        number: Int,
        sequence: StorageSequence
    ) async throws(StorageClientError) -> StorageMultipartChunk {
        throw .invalidKey
    }
    func abort(multipartId: String, key: String)
        async throws(StorageClientError)
    {}
    func finish(
        multipartId: String,
        key: String,
        chunks: [StorageMultipartChunk]
    ) async throws(StorageClientError) {}
}
