import BlogModule
import FeatherDBAL

import struct Foundation.Date

extension Post.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let title: String
        let excerpt: String
        let content: String
        let imageAssetId: String?
        let authorIds: String
        let tagIds: String
    }
    }

    extension Post.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let title: String
        let excerpt: String
        let content: String
        let imageAssetId: String?
        let authorIds: String
        let tagIds: String

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Post.Table.columns.updatedAt] = .currentTimestamp
        }
    }
    }

    extension Post.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let title: String
        let excerpt: String
        let content: String
        let imageAssetId: String?
        let authorIds: String
        let tagIds: String
        let createdAt: Date
        let updatedAt: Date
    }
    }

    extension Post.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let title: String
        let excerpt: String
        let imageAssetId: String?
        let createdAt: Date
        let updatedAt: Date
    }
}

extension Post.Table: DatabaseTableWithDelete {}
