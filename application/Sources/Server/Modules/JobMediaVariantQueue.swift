import Jobs
import MediaBackend

struct JobMediaVariantQueue: MediaVariantQueue {
    let queue: any JobQueueProtocol

    func enqueueMediaGenerateVariant(
        assetId: String,
        variantProcessorId: String
    ) async throws {
        try await queue.enqueueMediaGenerateVariant(
            assetId: assetId,
            processorId: variantProcessorId
        )
    }
}
