import FeatherDBAL
import FeatherDatabase
import Foundation
import MediaModule

extension Asset.Node.Table: DatabaseTableWithDelete {}

extension Asset.Node.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let parentId: String?
        let name: String
        let slug: String
        let absoluteSlug: String

        enum CodingKeys: String, CodingKey {
            case id
            case parentId = "parent_id"
            case name
            case slug
            case absoluteSlug = "absolute_slug"
        }
    }
}

extension Asset.Node.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let parentId: String?
        let name: String
        let slug: String
        let absoluteSlug: String

        enum CodingKeys: String, CodingKey {
            case parentId = "parent_id"
            case name
            case slug
            case absoluteSlug = "absolute_slug"
        }

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Asset.Node.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension Asset.Node.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let parentId: String?
        let name: String
        let slug: String
        let absoluteSlug: String
        let createdAt: Date
        let updatedAt: Date
        let deletedAt: Date?

        var row: Asset.Node.Table.Row {
            .init(
                id: id,
                parentId: parentId,
                name: name,
                slug: slug,
                slugPath: absoluteSlug.isEmpty
                    ? slug
                    : "\(absoluteSlug)/\(slug)",
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt
            )
        }
    }
}
