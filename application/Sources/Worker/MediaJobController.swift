import FeatherApplication
import FeatherDomain
import Environment
import FeatherDatabase
import FeatherDatabasePostgres
import FeatherInfrastructure
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
        storage: any MediaStorage
    ) {
        queue.registerJob(parameters: GenerateVariantJob.self) {
            parameters,
            _ in
            let transaction = DatabaseTransactionExecutor(
                database: database,
                idGenerator: idGenerator,
                scope: { context in
                    return WriteMedia(
                        folders: MediaFolderDatabaseRepository(
                            context: context
                        ),
                        assets: MediaAssetDatabaseRepository(context: context),
                        processors: MediaProcessorDatabaseRepository(
                            context: context
                        ),
                        processorAssets: MediaProcessorAssetDatabaseRepository(
                            context: context
                        )
                    )
                }
            )

            let useCase = GenerateMediaAssetVariant(
                transaction: transaction,
                storage: storage,
                shellRunner: SubprocessMediaShellRunner()
            )

            try await useCase.execute(
                input: .init(
                    assetId: parameters.assetId,
                    processorId: parameters.processorId
                )
            )
        }
    }
}
