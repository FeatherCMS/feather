public struct MediaGenerateVariantJobPayload: Codable, Sendable {
    public static let jobName = "media_generate_variant"

    public let assetId: String
    public let processorId: String

    public init(assetId: String, processorId: String) {
        self.assetId = assetId
        self.processorId = processorId
    }
}
