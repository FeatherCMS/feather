public protocol MediaJobs: Sendable {
    func enqueueMediaGenerateVariants(assetId: String) async throws
}
