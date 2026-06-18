import Testing
import Application
import MediaDomain
import Foundation
@testable import MediaApplication

@Suite
struct MediaVariantGenerationTestSuite {
    @Test
    func processingJobsCompleteAssetWhenAllMatchingProcessorsFinish()
        async throws
    {
        let assetRepo = MockAssetRepository(
            asset: .init(
                id: "asset-3",
                storageKey: "media/assets/asset-3.jpg",
                type: "jpeg",
                sizeBytes: 123,
                status: .processing,
                title: nil,
                altText: nil,
                createdAt: Date(),
                updatedAt: Date(),
                deletedAt: nil
            )
        )
        let processorOne = MediaProcessor(
            id: "processor-1",
            name: "image_preview",
            matchExtensions: "jpg",
            commandTemplate: "cp {input.fullname} {output.fullname}",
            isRequired: false,
            isActive: true,
            createdAt: Date(),
            updatedAt: Date()
        )
        let processorTwo = MediaProcessor(
            id: "processor-2",
            name: "video_preview",
            matchExtensions: "jpg",
            commandTemplate: "cp {input.fullname} {output.fullname}",
            isRequired: false,
            isActive: true,
            createdAt: Date(),
            updatedAt: Date()
        )
        let processorRepo = MockProcessorRepository(active: [
            processorOne, processorTwo,
        ])
        let processorAssetRepo = MockProcessorAssetRepository()
        let transaction = MockTransactionExecutor(
            context: WriteMedia(
                assets: assetRepo,
                processors: processorRepo,
                processorAssets: processorAssetRepo
            )
        )
        let storage = MockStorage(downloadData: Data([7, 8, 9]))
        let shellRunner = MockShellRunner()
        let useCase = GenerateMediaAssetVariant(
            transaction: transaction,
            idGenerator: FixedIDGenerator(id: "link-id-1"),
            storage: storage,
            shellRunner: shellRunner
        )

        try await useCase.execute(
            input: .init(assetId: "asset-3", processorId: "processor-1")
        )

        #expect(await storage.downloadedKeys == ["media/assets/asset-3.jpg"])
        #expect(await shellRunner.commands.count == 1)
        #expect(
            await storage.uploadedKeys == [
                "media/assets/asset-3_image_preview.jpeg"
            ]
        )
        #expect(await processorAssetRepo.inserted.count == 1)
        #expect(await assetRepo.statusHistory == [.processing])

        try await useCase.execute(
            input: .init(assetId: "asset-3", processorId: "processor-2")
        )

        #expect(
            await storage.uploadedKeys == [
                "media/assets/asset-3_image_preview.jpeg",
                "media/assets/asset-3_preview.jpeg",
            ]
        )
        #expect(await processorAssetRepo.inserted.count == 2)
        #expect(await assetRepo.statusHistory == [.processing, .ready])
    }

    @Test
    func processorCanGenerateOutputWithDifferentExtension() async throws {
        let assetRepo = MockAssetRepository(
            asset: .init(
                id: "asset-4",
                storageKey: "media/assets/asset-4.mov",
                type: "mov",
                sizeBytes: 456,
                status: .processing,
                title: nil,
                altText: nil,
                createdAt: Date(),
                updatedAt: Date(),
                deletedAt: nil
            )
        )
        let processor = MediaProcessor(
            id: "processor-preview",
            name: "video_preview",
            matchExtensions: "mov",
            commandTemplate:
                "cp {input.fullname} {output.dirname}/{output.basename}.png",
            isRequired: false,
            isActive: true,
            createdAt: Date(),
            updatedAt: Date()
        )
        let processorRepo = MockProcessorRepository(active: [processor])
        let processorAssetRepo = MockProcessorAssetRepository()
        let transaction = MockTransactionExecutor(
            context: WriteMedia(
                assets: assetRepo,
                processors: processorRepo,
                processorAssets: processorAssetRepo
            )
        )
        let storage = MockStorage(downloadData: Data([1, 2, 3]))
        let shellRunner = MockShellRunner()
        let useCase = GenerateMediaAssetVariant(
            transaction: transaction,
            idGenerator: FixedIDGenerator(id: "link-id-2"),
            storage: storage,
            shellRunner: shellRunner
        )

        try await useCase.execute(
            input: .init(assetId: "asset-4", processorId: "processor-preview")
        )

        #expect(
            await storage.uploadedKeys == ["media/assets/asset-4_preview.png"]
        )
        #expect(await assetRepo.statusHistory == [.ready])
    }
}

private struct FixedIDGenerator: IDGenerator {
    let id: String
    func generate() -> String { id }
}

private actor MockTransactionExecutor<S: Scope>: TransactionExecutor {
    let context: S

    init(context: S) {
        self.context = context
    }

    func run<T: Sendable>(
        _ body: @Sendable (S) async throws -> T
    ) async throws -> T {
        try await body(context)
    }
}

private actor MockAssetRepository: MediaAssetRepository {
    var asset: MediaAsset
    private(set) var statusHistory: [MediaAsset.Status] = []

    init(asset: MediaAsset) {
        self.asset = asset
    }

    func insert(
        _ model: MediaAsset.New
    ) async throws -> MediaAsset {
        _ = model
        throw MockError.unused
    }

    func update(
        _ model: MediaAsset
    ) async throws -> MediaAsset {
        statusHistory.append(model.status)
        asset = model
        return model
    }

    func find(
        id: String
    ) async throws -> MediaAsset? {
        id == asset.id ? asset : nil
    }

    func delete(
        id: String
    ) async throws -> Bool {
        _ = id
        return false
    }
}

private actor MockProcessorRepository: MediaProcessorRepository {
    let active: [MediaProcessor]

    init(active: [MediaProcessor]) {
        self.active = active
    }

    func insert(
        _ model: MediaProcessor.New
    ) async throws -> MediaProcessor {
        _ = model
        throw MockError.unused
    }

    func find(
        id: String
    ) async throws -> MediaProcessor? {
        active.first { $0.id == id }
    }

    func list() async throws -> [MediaProcessor] {
        active
    }

    func listActive() async throws -> [MediaProcessor] {
        active.filter { $0.isActive }
    }

    func update(
        _ model: MediaProcessor
    ) async throws -> MediaProcessor {
        model
    }

    func delete(
        id: String
    ) async throws -> Bool {
        _ = id
        return false
    }
}

private actor MockProcessorAssetRepository: MediaProcessorAssetRepository {
    private(set) var inserted: [MediaProcessorAsset.New] = []

    func insert(
        _ model: MediaProcessorAsset.New
    ) async throws -> MediaProcessorAsset {
        inserted.append(model)
        return .init(
            id: model.id,
            assetId: model.assetId,
            processorId: model.processorId,
            storageKey: model.storageKey,
            createdAt: Date()
        )
    }

    func find(
        assetId: String,
        processorId: String
    ) async throws -> MediaProcessorAsset? {
        for model in inserted
        where model.assetId == assetId && model.processorId == processorId {
            return .init(
                id: model.id,
                assetId: model.assetId,
                processorId: model.processorId,
                storageKey: model.storageKey,
                createdAt: Date()
            )
        }
        return nil
    }

    func list(
        assetId: String
    ) async throws -> [MediaProcessorAsset] {
        inserted.filter { $0.assetId == assetId }
            .map {
                .init(
                    id: $0.id,
                    assetId: $0.assetId,
                    processorId: $0.processorId,
                    storageKey: $0.storageKey,
                    createdAt: Date()
                )
            }
    }
}

private actor MockStorage: MediaStorage {
    let downloadData: Data
    private(set) var downloadedKeys: [String] = []
    private(set) var uploadedKeys: [String] = []

    init(downloadData: Data) {
        self.downloadData = downloadData
    }

    func download(
        key: String
    ) async throws -> Data {
        downloadedKeys.append(key)
        return downloadData
    }

    func upload(
        key: String,
        data: Data
    ) async throws {
        _ = data
        uploadedKeys.append(key)
    }

    func delete(
        key: String
    ) async throws {
        _ = key
    }
}

private actor MockShellRunner: MediaShellRunner {
    private(set) var commands: [String] = []

    func run(
        command: String
    ) async throws -> MediaCommandResult {
        commands.append(command)

        let parts = command.split(whereSeparator: { $0.isWhitespace })
            .map(String.init)
        guard parts.count >= 3 else {
            throw MockError.invalidCommand(command)
        }

        let inputPath = parts[parts.count - 2]
        let outputPath = parts[parts.count - 1]
        let inputURL = URL(fileURLWithPath: inputPath)
        let outputURL = URL(fileURLWithPath: outputPath)
        try Data(contentsOf: inputURL).write(to: outputURL)

        return .init(exitCode: 0, standardOutput: nil, standardError: nil)
    }
}

private enum MockError: Error {
    case unused
    case invalidCommand(String)
}
