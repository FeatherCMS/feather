public import FeatherApplication
public import FeatherInfrastructure
public import Jobs
public import MediaApplication
public import MediaModule

extension Asset.File.GenerateVariant.JobController {
    public struct JobQueue: Interface {
        public let queue: any JobQueueProtocol

        public init(queue: any JobQueueProtocol) {
            self.queue = queue
        }

        public static func register(
            on queue: some JobQueueProtocol,
            databaseContext: DatabaseClientContext,
            storageContext: StorageClientContext,
            maxConcurrentProcessing: Int,
            logFailure: @escaping @Sendable (String, String) -> Void = { _, _ in
            }
        ) {
            Asset.File.GenerateVariant.Job.Handler.register(
                on: queue,
                databaseContext: databaseContext,
                storageContext: storageContext,
                maxConcurrentProcessing: maxConcurrentProcessing,
                logFailure: logFailure
            )
        }

        public func enqueue(assetId: String) async throws {
            _ = try await queue.push(
                Asset.File.GenerateVariant.Job.Parameters(assetId: assetId)
            )
        }
    }
}
