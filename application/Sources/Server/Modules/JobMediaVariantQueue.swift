import Jobs
import MediaBackend

struct JobMediaVariantQueue: MediaVariantQueue {
    let queue: any JobQueueProtocol

    func enqueueMediaGenerateVariant(
        assetId: String,
        processorId: String
    ) async throws {
        try await queue.enqueueMediaGenerateVariant(
            assetId: assetId,
            processorId: processorId
        )
    }
}
