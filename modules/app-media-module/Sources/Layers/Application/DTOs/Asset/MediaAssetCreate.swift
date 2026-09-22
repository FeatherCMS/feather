import FeatherApplication

public struct MediaAssetCreate: DTO {
    public let folderId: String?
    public let fileName: String
    public let `extension`: String
    public let title: String?
    public let altText: String?

    public init(
        folderId: String? = nil,
        fileName: String,
        `extension`: String,
        title: String? = nil,
        altText: String? = nil
    ) {
        self.folderId = folderId
        self.fileName = fileName
        self.extension = `extension`
        self.title = title
        self.altText = altText
    }
}
