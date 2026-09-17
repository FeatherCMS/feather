public protocol MediaVariantQueue: Sendable {
    func enqueueMediaGenerateVariant(
        assetId: String,
        variantProcessorId: String
    ) async throws
}
