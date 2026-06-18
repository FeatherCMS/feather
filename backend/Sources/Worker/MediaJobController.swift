import Application
import Environment
import FeatherDatabase
import FeatherDatabasePostgres
import FeatherStorageFS
import Infrastructure
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
        storageRootPath: String
    ) {
        queue.registerJob(parameters: GenerateVariantJob.self) {
            parameters,
            _ in
            let transaction = DatabaseTransactionExecutor(
                database: database,
                scope: { connection in
                    WriteMedia(
                        folders: DatabaseMediaFolderRepository(
                            connection: connection
                        ),
                        assets: DatabaseMediaAssetRepository(
                            connection: connection
                        ),
                        processors: DatabaseMediaProcessorRepository(
                            connection: connection
                        ),
                        processorAssets: DatabaseMediaProcessorAssetRepository(
                            connection: connection
                        )
                    )
                }
            )

            let useCase = GenerateMediaAssetVariant(
                transaction: transaction,
                idGenerator: idGenerator,
                storage: MediaStorageClient(
                    client: StorageClientFS(rootPath: storageRootPath)
                ),
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
