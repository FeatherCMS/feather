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
    struct GenerateVariantJob: JobParameters {
        static let jobName = MediaGenerateVariantJobPayload.jobName
        let assetId: String
        let processorId: String
    }

    init(
        queue: some JobQueueProtocol,
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        storage: any StorageClient,
        storageKeyShard: MediaStorageKeyShard
    ) {
        queue.registerJob(parameters: GenerateVariantJob.self) {
            parameters,
            _ in
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
                        variantProcessors: MediaVariantProcessorDatabaseRepository(
                            context: context
                        )
                    )
                }
            )

            let useCase = GenerateMediaAssetVariant(
                transaction: transaction,
                storage: storage,
                storageKeyShard: storageKeyShard,
                shellRunner: SubprocessMediaShellRunner()
            )

            try await useCase.execute(
                input: .init(
                    assetId: parameters.assetId,
                    variantProcessorId: parameters.processorId
                )
            )
        }
    }
}
