import Testing
import Application
import MediaDomain
import Foundation
@testable import MediaApplication

@Suite
struct MediaApplicationUploadTestSuite {

    @Test
    func uploadMediaAssetSuccess() async throws {
        let repository = MediaAssetMockRepository(mode: .success)
        let transaction = MockTransactionExecutor(
            context: WriteMedia(
                assets: repository,
                processors: NoopMediaProcessorRepository(),
                processorAssets: NoopMediaProcessorAssetRepository()
            )
        )
        let authorizer = MockAuthorizer(result: true)
        let storage = MockMediaStorage()
        let useCase = UploadMediaAsset(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: FixedIDGenerator(id: "asset-id"),
            storage: storage
        )

        let result = try await useCase.execute(
            subject: .init(id: "subject-1"),
            input: .init(
                storageKey: "media/assets/asset-id",
                type: "jpeg",
                title: "title",
                altText: "alt",
                data: Data([1, 2, 3])
            )
        )

        #expect(result.id == "asset-id")
        #expect(await authorizer.canCallCount == 1)
        #expect(await transaction.runCallCount == 1)
        #expect(await storage.uploadCallCount == 1)
        #expect(await storage.deleteCallCount == 0)
        #expect(await repository.insertCallCount == 1)
    }

    @Test
    func uploadMediaAssetForbidden() async {
        let repository = MediaAssetMockRepository(mode: .success)
        let transaction = MockTransactionExecutor(
            context: WriteMedia(
                assets: repository,
                processors: NoopMediaProcessorRepository(),
                processorAssets: NoopMediaProcessorAssetRepository()
            )
        )
        let authorizer = MockAuthorizer(result: false)
        let storage = MockMediaStorage()
        let useCase = UploadMediaAsset(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: FixedIDGenerator(id: "asset-id"),
            storage: storage
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: .init(id: "subject-1"),
                input: .init(
                    storageKey: "media/assets/asset-id",
                    type: "jpeg",
                    data: Data([1])
                )
            )
        }

        #expect(await transaction.runCallCount == 0)
        #expect(await storage.uploadCallCount == 0)
        #expect(await repository.insertCallCount == 0)
    }

    @Test
    func uploadMediaAssetRollsBackStorageWhenInsertFails() async {
        let repository = MediaAssetMockRepository(mode: .failure)
        let transaction = MockTransactionExecutor(
            context: WriteMedia(
                assets: repository,
                processors: NoopMediaProcessorRepository(),
                processorAssets: NoopMediaProcessorAssetRepository()
            )
        )
        let authorizer = MockAuthorizer(result: true)
        let storage = MockMediaStorage()
        let useCase = UploadMediaAsset(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: FixedIDGenerator(id: "asset-id"),
            storage: storage
        )

        await #expect(throws: Error.self) {
            _ = try await useCase.execute(
                subject: .init(id: "subject-1"),
                input: .init(
                    storageKey: "media/assets/asset-id",
                    type: "jpeg",
                    data: Data([9, 9, 9])
                )
            )
        }

        #expect(await storage.uploadCallCount == 1)
        #expect(await storage.deleteCallCount == 1)
    }
}

private struct FixedIDGenerator: IDGenerator {
    let id: String
    func generate() -> String { id }
}

private actor MockAuthorizer: Authorizer {
    let result: Bool
    private(set) var canCallCount: Int = 0

    init(result: Bool) {
        self.result = result
    }

    func can(
        subject: Subject,
        perform action: any Action
    ) async throws -> Bool {
        _ = subject
        _ = action
        canCallCount += 1
        return result
    }
}

private actor MockTransactionExecutor<S: Scope>: TransactionExecutor {
    let context: S
    private(set) var runCallCount: Int = 0

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

private actor MockMediaStorage: MediaStorage {
    private(set) var uploadCallCount: Int = 0
    private(set) var deleteCallCount: Int = 0

    func download(
        key: String
    ) async throws -> Data {
        _ = key
        return Data()
    }

    func upload(
        key: String,
        data: Data
    ) async throws {
        _ = key
        _ = data
        uploadCallCount += 1
    }

    func delete(
        key: String
    ) async throws {
        _ = key
        deleteCallCount += 1
    }
}

private enum MediaRepoMode {
    case success
    case failure
}

private actor MediaAssetMockRepository: MediaAssetRepository {
    let mode: MediaRepoMode
    private(set) var insertCallCount: Int = 0

    init(mode: MediaRepoMode) {
        self.mode = mode
    }

    func insert(
        _ model: MediaAsset.New
    ) async throws -> MediaAsset {
        insertCallCount += 1
        switch mode {
        case .success:
            return .init(
                id: model.id,
                storageKey: model.storageKey,
                type: model.type,
                sizeBytes: model.sizeBytes,
                status: model.status,
                title: model.title,
                altText: model.altText,
                createdAt: Date(),
                updatedAt: Date(),
                deletedAt: nil
            )
        case .failure:
            throw MockError.failed
        }
    }

    func update(
        _ model: MediaAsset
    ) async throws -> MediaAsset { model }
    func find(
        id: String
    ) async throws -> MediaAsset? {
        _ = id
        return nil
    }
    func delete(
        id: String
    ) async throws -> Bool {
        _ = id
        return true
    }
}

private actor NoopMediaProcessorRepository: MediaProcessorRepository {
    func insert(
        _ model: MediaProcessor.New
    ) async throws -> MediaProcessor {
        _ = model
        throw MockError.unused
    }
    func update(
        _ model: MediaProcessor
    ) async throws -> MediaProcessor {
        model
    }
    func find(
        id: String
    ) async throws -> MediaProcessor? {
        _ = id
        return nil
    }
    func list() async throws -> [MediaProcessor] { [] }
    func listActive() async throws -> [MediaProcessor] { [] }
    func delete(
        id: String
    ) async throws -> Bool {
        _ = id
        return false
    }
}

private actor NoopMediaProcessorAssetRepository: MediaProcessorAssetRepository {
    func insert(
        _ model: MediaProcessorAsset.New
    ) async throws -> MediaProcessorAsset {
        _ = model
        throw MockError.unused
    }
    func find(
        assetId: String,
        processorId: String
    ) async throws -> MediaProcessorAsset? {
        _ = assetId
        _ = processorId
        return nil
    }
    func list(
        assetId: String
    ) async throws -> [MediaProcessorAsset] {
        _ = assetId
        return []
    }
}

private enum MockError: Error {
    case failed
    case unused
}
