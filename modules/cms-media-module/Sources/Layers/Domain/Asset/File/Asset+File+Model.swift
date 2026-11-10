public import FeatherDomain
public import Foundation
public import MediaModule

extension Asset.File {
    public struct Model: FeatherDomain.Model {

        public enum Status: String, Sendable {
            case uploaded
            case processing
            case ready
        }

        public struct New: Sendable {
            public let folderId: String?
            public let name: String
            public let slug: String
            public let slugPath: String
            public let storageObjectId: String
            public let `extension`: String
            public let contentType: String
            public let sizeBytes: Int64
            public let status: Status
            public let title: String?
            public let altText: String?
        }

        public let id: String
        public var folderId: String?
        public var name: String
        public var slug: String
        public var slugPath: String
        public let storageObjectId: String
        public let `extension`: String
        public let contentType: String
        public let sizeBytes: Int64
        public var status: Status
        public var title: String?
        public var altText: String?
        public let createdAt: Date
        public let updatedAt: Date
        public let deletedAt: Date?

        package init(
            id: String,
            folderId: String?,
            name: String,
            slug: String,
            slugPath: String,
            storageObjectId: String,
            `extension`: String,
            contentType: String,
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
            self.name = name
            self.slug = slug
            self.slugPath = slugPath
            self.storageObjectId = storageObjectId
            self.extension = `extension`
            self.contentType = contentType
            self.sizeBytes = sizeBytes
            self.status = status
            self.title = title
            self.altText = altText
            self.createdAt = createdAt
            self.updatedAt = updatedAt
            self.deletedAt = deletedAt
        }
    }
}

extension Asset.File.Model {
    public static func slug(from name: String) -> String {
        Slug.Segment(normalizing: name).value
    }

    public mutating func update(
        name: FieldChange<String> = .unchanged,
        title: OptionalFieldChange<String> = .unchanged,
        altText: OptionalFieldChange<String> = .unchanged
    ) {
        if case .set(let value) = name {
            let updatedName = value.trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            let normalizedSlug = Slug.Segment(
                normalizing: updatedName
            ).value
            if normalizedSlug != self.name || normalizedSlug != self.slug {
                let segments = slugPath.split(separator: "/")
                let parentPath = segments.dropLast().joined(separator: "/")
                self.name = normalizedSlug
                self.slug = normalizedSlug
                self.slugPath = parentPath.isEmpty
                    ? normalizedSlug
                    : "\(parentPath)/\(normalizedSlug)"
            }
        }
        self.title = title.apply(to: self.title)
        self.altText = altText.apply(to: self.altText)
    }

    public static func create(
        folderId: String?,
        name: String,
        slug: String,
        slugPath: String,
        storageObjectId: String,
        extension ext: String,
        contentType: String,
        sizeBytes: Int64,
        title: String?,
        altText: String?
    ) -> Self.New {
        .init(
            folderId: folderId,
            name: name,
            slug: slug,
            slugPath: slugPath,
            storageObjectId: storageObjectId,
            extension: ext,
            contentType: contentType,
            sizeBytes: sizeBytes,
            status: .uploaded,
            title: title,
            altText: altText
        )
    }
}
