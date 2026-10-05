public import FeatherApplication
public import FeatherInfrastructure
public import Jobs
import FeatherStorage
import MediaApplication
import MediaDomain

private actor ProcessingCoordinator {
    private let limit: Int
    private var activeAssetIDs: Set<String> = []
    private var activeCount = 0
    private var waiters: [CheckedContinuation<Void, Never>] = []

    init(limit: Int) {
        self.limit = max(1, limit)
    }

    func acquire(assetID: String) async -> Bool {
        guard activeAssetIDs.insert(assetID).inserted else {
            return false
        }
        if activeCount >= limit {
            await withCheckedContinuation { continuation in
                waiters.append(continuation)
            }
        }
        activeCount += 1
        return true
    }

    func release(assetID: String) {
        guard activeAssetIDs.remove(assetID) != nil else { return }
        activeCount = max(0, activeCount - 1)
        guard activeCount < limit, !waiters.isEmpty else { return }
        waiters.removeFirst().resume()
    }
}

public enum MediaGenerateVariantJobHandler {
    public static func handle(
        parameters: MediaGenerateVariantJobParameters,
        databaseContext: DatabaseClientContext,
        storageContext: StorageClientContext
    ) async throws {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteMedia(
                    folders: MediaAssetNodeFolderDatabaseRepository(
                        context: context
                    ),
                    assets: MediaAssetNodeFileDatabaseRepository(
                        context: context
                    ),
                    storageObjects:
                        MediaAssetStorageObjectDatabaseRepository(
                            context: context
                        ),
                    variants: MediaAssetNodeFileVariantDatabaseRepository(
                        context: context
                    ),
                    variantDefinitions: MediaVariantDatabaseRepository(
                        context: context
                    ),
                    variantProcessors:
                        MediaVariantProcessorDatabaseRepository(
                            context: context
                        )
                )
            }
        )

        let useCase = GenerateMediaAssetVariants(
            transaction: transaction,
            storageContext: storageContext,
            commandRunner: SubprocessCommandRunner()
        )
        try await useCase.execute(
            input: .init(assetId: parameters.assetId)
        )
    }

    public static func register(
        on queue: some JobQueueProtocol,
        databaseContext: DatabaseClientContext,
        storageContext: StorageClientContext,
        maxConcurrentProcessing: Int,
        logFailure: @escaping @Sendable (String, String) -> Void = { _, _ in }
    ) {
        let coordinator = ProcessingCoordinator(
            limit: maxConcurrentProcessing
        )
        queue.registerJob(parameters: MediaGenerateVariantJobParameters.self) {
            parameters,
            _ in
            guard await coordinator.acquire(assetID: parameters.assetId) else {
                return
            }
            do {
                try await handle(
                    parameters: parameters,
                    databaseContext: databaseContext,
                    storageContext: storageContext
                )
                await coordinator.release(assetID: parameters.assetId)
            }
            catch {
                await coordinator.release(assetID: parameters.assetId)
                logFailure(
                    parameters.assetId,
                    String(reflecting: error)
                )
                throw error
            }
        }
    }
}
