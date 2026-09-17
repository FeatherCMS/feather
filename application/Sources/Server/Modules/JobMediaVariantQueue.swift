import Jobs
import MediaBackend

struct JobMediaVariantQueue: MediaVariantQueue {
    let queue: any JobQueueProtocol

    func enqueueMediaGenerateVariants(assetId: String) async throws {
        try await queue.enqueueMediaGenerateVariants(assetId: assetId)
    }
}
