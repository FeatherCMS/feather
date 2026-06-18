import Environment
import Jobs

extension JobQueueProtocol {
    func enqueueMediaGenerateVariant(
        assetId: String,
        processorId: String
    ) async throws {
        _ = try await push(
            .init(MediaGenerateVariantJobPayload.jobName),
            parameters: MediaGenerateVariantJobPayload(
                assetId: assetId,
                processorId: processorId
            )
        )
    }
}
