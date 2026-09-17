import FeatherApplication
import FeatherDomain
import Environment
import FeatherDatabase
import FeatherDatabasePostgres
import FeatherInfrastructure
import FeatherStorage
import Jobs
import MediaApplication
import MediaDomain
import MediaInfrastructure

struct MediaJobController {
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

    struct GenerateVariantJob: JobParameters {
        static let jobName = MediaGenerateVariantJobPayload.jobName
        let assetId: String
    }

    init(
        queue: some JobQueueProtocol,
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        storage: any StorageClient,
        storageKeyShard: MediaStorageKeyShard,
        maxConcurrentProcessing: Int
    ) {
        let coordinator = ProcessingCoordinator(limit: maxConcurrentProcessing)
        queue.registerJob(parameters: GenerateVariantJob.self) {
            parameters,
            _ in
            guard await coordinator.acquire(assetID: parameters.assetId) else {
                return
            }
            let transaction = DatabaseTransactionExecutor(
                database: database,
                idGenerator: idGenerator,
                scope: { context in
                    return WriteMedia(
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
                storage: storage,
                storageKeyShard: storageKeyShard,
                shellRunner: SubprocessMediaShellRunner()
            )

            do {
                try await useCase.execute(
                    input: .init(assetId: parameters.assetId)
                )
                await coordinator.release(assetID: parameters.assetId)
            }
            catch {
                await coordinator.release(assetID: parameters.assetId)
                throw error
            }
        }
    }
}
