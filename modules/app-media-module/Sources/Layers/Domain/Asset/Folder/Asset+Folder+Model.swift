public import FeatherDomain
public import MediaModule

public import Foundation

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
    private static func slug(from name: String) -> String {
        name.lowercased()
            .replacingOccurrences(
                of: "[^a-z0-9]+",
                with: "-",
                options: .regularExpression
            )
            .trimmingCharacters(in: CharacterSet(charactersIn: "-"))
    }

    public mutating func update(
        name: FieldChange<String>,
        parentPath: String?
    ) throws(Error) {
        let name = name.apply(to: self.name).trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        let slug = Self.slug(from: name)
        guard !name.isEmpty, !slug.isEmpty else {
            throw .invalidName
        }

        self.name = name
        self.slug = slug
        self.slugPath = parentPath.map { "\($0)/\(slug)" } ?? slug
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
        let slug = Self.slug(from: name)
        guard !name.isEmpty, !slug.isEmpty else {
            throw .invalidName
        }

        return .init(
            parentId: parentId,
            name: name,
            slug: slug,
            slugPath: parentPath.map { "\($0)/\(slug)" } ?? slug,
            assetCount: 0,
            totalSizeBytes: 0
        )
    }
}
