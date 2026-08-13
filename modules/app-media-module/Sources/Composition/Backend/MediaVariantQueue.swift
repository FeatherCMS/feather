public protocol MediaVariantQueue: Sendable {
    func enqueueMediaGenerateVariant(
        assetId: String,
        processorId: String
    ) async throws
}
