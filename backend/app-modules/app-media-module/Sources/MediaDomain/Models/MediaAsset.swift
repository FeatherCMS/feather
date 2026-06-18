import Domain
import struct Foundation.Date
import struct Foundation.URL

public struct MediaAsset: Model {

    public enum Status: String, Sendable {
        case uploaded
        case processing
        case ready
    }

    public struct New: Sendable {
        public let id: String
        public let folderId: String?
        public let storageKey: String
        public let baseName: String
        public let type: String
        public let sizeBytes: Int64
        public let status: Status
        public let title: String?
        public let altText: String?
    }

    public let id: String
    public var folderId: String?
    public var storageKey: String
    public var baseName: String
    public var type: String
    public var sizeBytes: Int64
    public var status: Status
    public var title: String?
    public var altText: String?
    public let createdAt: Date
    public let updatedAt: Date
    public let deletedAt: Date?

    package init(
        id: String,
        folderId: String?,
        storageKey: String,
        baseName: String,
        type: String,
        sizeBytes: Int64,
        status: Status,
        title: String?,
        altText: String?,
        createdAt: Date,
        updatedAt: Date,
        deletedAt: Date?
    ) {
        self.id = id
        self.folderId = folderId
        self.storageKey = storageKey
        self.baseName = baseName
        self.type = type
        self.sizeBytes = sizeBytes
        self.status = status
        self.title = title
        self.altText = altText
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }
}

public extension MediaAsset {
    static func create(
        id: String,
        folderId: String?,
        storageKey: String,
        type: String,
        sizeBytes: Int64,
        title: String?,
        altText: String?
    ) -> Self.New {
        .init(
            id: id,
            folderId: folderId,
            storageKey: storageKey,
            baseName: fileBaseName(from: storageKey),
            type: type,
            sizeBytes: sizeBytes,
            status: .uploaded,
            title: title,
            altText: altText
        )
    }

    private static func fileBaseName(
        from storageKey: String
    ) -> String {
        let lastPathComponent =
            storageKey
            .split(separator: "/")
            .last
            .map(String.init)
            ?? storageKey
        return URL(fileURLWithPath: lastPathComponent)
            .deletingPathExtension()
            .lastPathComponent
    }
}
