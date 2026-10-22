import BlogAdminAPI
import BlogBackend
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
import MediaApplication
import MediaBackend
import MediaModule
import OpenAPIHummingbird
import OpenAPIRuntime
import Testing

@Suite
struct BlogAPIHTTPTestSuite {
    private enum QueryKey: DatabaseQueryKey {
        case authorList
    }

    @Test
    func adminAuthorListUsesGeneratedRouterAndDatabaseQuery() async throws {
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [.init(key: .authorList)]
        )
        let executor = try makeExecutor(connection: connection)
        let request = FeatherHTTP.Request(
            method: .get,
            path: "/api/v1/admin/blog/authors/"
        )

        try await CurrentSubject.set(subject: Subject(id: "admin-1")) {
            try await executor.withOperation(request: request) { response in
                #expect(response.status.code == 200)
                #expect(try await response.plainTextBody() == "[]")
            }
        }

        try await connection.assertAllResponsesConsumed()
    }

    private func makeExecutor<Key: DatabaseQueryKey>(
        connection: MockDatabaseConnection<Key>
    ) throws -> HummingbirdTestingHTTPExecutor {
        let databaseContext = DatabaseClientContext(
            database: FeatherTesting.DatabaseClient.Mock(
                connection: connection
            ),
            idGenerator: FeatherTesting.IDGenerator.Mock(id: "blog-test-id"),
            platform: MockDatabasePlatform()
        )
        let storageContext = StorageClientContext(
            storage: UnusedStorageClient(),
            objectKeyGenerator: TestObjectKeyGenerator()
        )
        let mediaUseCases = MediaBackend.UseCases(
            databaseContext: databaseContext,
            storageContext: storageContext,
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            jobs: UnusedJobController()
        )
        let gateway = AdminAPIGateway(
            useCases: BlogBackend.UseCases(
                databaseContext: databaseContext,
                authorizer: FeatherTesting.Authorizer.Mock(result: true),
                media: mediaUseCases,
                mediaResolver: MediaResolver(
                    mediaBaseURL: URL(string: "https://media.test")!
                )
            )
        )
        let router = Router()
        try gateway.registerHandlers(on: router)
        return HummingbirdTestingHTTPExecutor(
            app: Application(router: router),
            testingSetup: .router
        )
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
    {
        throw .invalidKey
    }

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
    {
        throw .invalidKey
    }

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
