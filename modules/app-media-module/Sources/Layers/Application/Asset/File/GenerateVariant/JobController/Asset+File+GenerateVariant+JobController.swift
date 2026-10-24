public import MediaModule

extension Asset.File.GenerateVariant.JobController {
    public protocol Interface: Sendable {
        func enqueue(assetId: String) async throws
    }
}
