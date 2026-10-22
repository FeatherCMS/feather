public import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
import FeatherStorage
public import Jobs
import MediaApplication
import MediaDomain
public import MediaModule

extension Asset.File.GenerateVariant.Job {
    public enum Handler {
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

        public static func handle(
            parameters: Parameters,
            databaseContext: DatabaseClientContext,
            storageContext: StorageClientContext
        ) async throws {
            let transaction = DatabaseTransactionExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Asset.File.GenerateVariant.Scope(
                        assets: Asset.File.Repository.Database(
                            context: context
                        ),
                        storageObjects: StorageObject.Repository.Database(
                            context: context
                        ),
                        variants: Asset.File.Variant.Repository.Database(
                            context: context
                        ),
                        variantDefinitions: Variant.Repository.Database(
                            context: context
                        ),
                        variantProcessors:
                            Variant.Processor.Repository.Database(
                                context: context
                            )
                    )
                }
            )

            let useCase = Asset.File.GenerateVariant.UseCase(
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
            logFailure: @escaping @Sendable (String, String) -> Void = { _, _ in
            }
        ) {
            let coordinator = ProcessingCoordinator(
                limit: maxConcurrentProcessing
            )
            queue.registerJob(parameters: Parameters.self) { parameters, _ in
                guard await coordinator.acquire(assetID: parameters.assetId)
                else {
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
}
