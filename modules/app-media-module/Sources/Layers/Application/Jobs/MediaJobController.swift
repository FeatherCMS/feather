public protocol MediaJobController: Sendable {
    func enqueueMediaGenerateVariants(assetId: String) async throws
}
