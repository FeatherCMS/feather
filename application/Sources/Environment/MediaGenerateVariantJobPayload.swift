public struct MediaGenerateVariantJobPayload: Codable, Sendable {
    public static let jobName = "media_generate_variant"

    public let assetId: String

    public init(assetId: String) {
        self.assetId = assetId
    }
}
