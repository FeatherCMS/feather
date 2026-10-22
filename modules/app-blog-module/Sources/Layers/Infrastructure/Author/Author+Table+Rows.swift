import BlogModule
import FeatherDBAL

import struct Foundation.Date

extension Author.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let key: String
        let name: String
        let notes: String
        let excerpt: String
        let profileImageAssetId: String?
        let content: String
    }
}

extension Author.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let key: String
        let name: String
        let notes: String
        let excerpt: String
        let profileImageAssetId: String?
        let content: String

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Author.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension Author.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let key: String
        let name: String
        let notes: String
        let excerpt: String
        let profileImageAssetId: String?
        let content: String
        let createdAt: Date
        let updatedAt: Date
    }
}

extension Author.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let name: String
        let excerpt: String
        let profileImageAssetId: String?
        let createdAt: Date
        let updatedAt: Date
    }
}

extension Author.Table: DatabaseTableWithDelete {}
