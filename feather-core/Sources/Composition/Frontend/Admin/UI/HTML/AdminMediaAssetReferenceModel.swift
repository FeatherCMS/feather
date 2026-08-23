import Foundation

public struct AdminMediaAssetReferenceModel: Codable, Sendable, Equatable,
    Hashable
{
    public let id: String
    public let storageKey: String
    public let baseName: String
    public let type: String
    public let title: String?
    public let altText: String?
    public let status: String

    public init(
        id: String,
        storageKey: String,
        baseName: String,
        type: String,
        title: String?,
        altText: String?,
        status: String
    ) {
        self.id = id
        self.storageKey = storageKey
        self.baseName = baseName
        self.type = type
        self.title = title
        self.altText = altText
        self.status = status
    }
}
