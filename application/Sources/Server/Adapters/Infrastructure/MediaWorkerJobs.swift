import Environment
import Jobs
import MediaApplication

struct MediaWorkerJobs: MediaJobs {
    let queue: any JobQueueProtocol

    func enqueueMediaGenerateVariants(assetId: String) async throws {
        _ = try await queue.push(
            .init(MediaGenerateVariantJobPayload.jobName),
            parameters: MediaGenerateVariantJobPayload(assetId: assetId)
        )
    }
}
