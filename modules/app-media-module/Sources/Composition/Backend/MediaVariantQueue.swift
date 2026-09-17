public protocol MediaVariantQueue: Sendable {
    func enqueueMediaGenerateVariants(assetId: String) async throws
}
