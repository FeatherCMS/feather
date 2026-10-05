public import FeatherApplication
public import FeatherInfrastructure
public import Jobs
public import MediaApplication

public struct JobQueueMediaJobController: MediaJobController {
    public let queue: any JobQueueProtocol

    public init(queue: any JobQueueProtocol) {
        self.queue = queue
    }

    public static func register(
        on queue: some JobQueueProtocol,
        databaseContext: DatabaseClientContext,
        storageContext: StorageClientContext,
        maxConcurrentProcessing: Int,
        logFailure: @escaping @Sendable (String, String) -> Void = { _, _ in }
    ) {
        MediaGenerateVariantJobHandler.register(
            on: queue,
            databaseContext: databaseContext,
            storageContext: storageContext,
            maxConcurrentProcessing: maxConcurrentProcessing,
            logFailure: logFailure
        )
    }

    public func enqueueMediaGenerateVariants(assetId: String) async throws {
        _ = try await queue.push(
            MediaGenerateVariantJobParameters(assetId: assetId)
        )
    }
}
