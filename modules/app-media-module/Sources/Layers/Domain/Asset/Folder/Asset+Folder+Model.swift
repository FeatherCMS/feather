public import FeatherDomain
public import Foundation
public import MediaModule

extension Asset.Folder {
    public struct Model: FeatherDomain.Model {
        public enum Error: DomainError {
            case invalidName
        }

        public struct New: Sendable {
            public let parentId: String?
            public let name: String
            public let slug: String
            public let slugPath: String
            public let assetCount: Int
            public let totalSizeBytes: Int64
        }

        public let id: String
        public var parentId: String?
        public var name: String
        public var slug: String
        public var slugPath: String
        public var assetCount: Int
        public var totalSizeBytes: Int64
        public let createdAt: Date
        public let updatedAt: Date
        public let deletedAt: Date?

        package init(
            id: String,
            parentId: String?,
            name: String,
            slug: String,
            slugPath: String,
            assetCount: Int,
            totalSizeBytes: Int64,
            createdAt: Date,
            updatedAt: Date,
            deletedAt: Date?
        ) {
            self.id = id
            self.parentId = parentId
            self.name = name
            self.slug = slug
            self.slugPath = slugPath
            self.assetCount = assetCount
            self.totalSizeBytes = totalSizeBytes
            self.createdAt = createdAt
            self.updatedAt = updatedAt
            self.deletedAt = deletedAt
        }
    }
}

extension Asset.Folder.Model {
    public mutating func update(
        name: FieldChange<String>,
        parentId: String?,
        parentPath: String?
    ) throws(Error) {
        let name = name.apply(to: self.name)
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
        guard !name.isEmpty else {
            throw .invalidName
        }

        let slug = Slug.Segment(normalizing: name)
        guard !slug.value.isEmpty else {
            throw .invalidName
        }

        let slugPath = parentPath.map {
            Slug(parsing: $0).appending(name).path
        } ?? slug.value

        self.name = name
        self.slug = slug.value
        self.slugPath = slugPath
        self.parentId = parentId
    }

    public mutating func updateAggregates(
        assetCountDelta: Int,
        totalSizeBytesDelta: Int64
    ) {
        assetCount += assetCountDelta
        totalSizeBytes += totalSizeBytesDelta
    }

    public static func create(
        parentId: String?,
        name: String,
        parentPath: String?
    ) throws(Error) -> Self.New {
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else {
            throw .invalidName
        }

        let slug = Slug.Segment(normalizing: name)
        guard !slug.value.isEmpty else {
            throw .invalidName
        }

        let slugPath = parentPath.map {
            Slug(parsing: $0).appending(name).path
        } ?? slug.value

        return .init(
            parentId: parentId,
            name: name,
            slug: slug.value,
            slugPath: slugPath,
            assetCount: 0,
            totalSizeBytes: 0
        )
    }
}
