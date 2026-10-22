import FeatherDBAL
import WebDomain

import struct Foundation.Date

extension Page.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let title: String
        let excerpt: String
        let content: String
        let imageAssetId: String?
    }
    }

    extension Page.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let title: String
        let excerpt: String
        let content: String
        let imageAssetId: String?

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Page.Table.columns.updatedAt] = .currentTimestamp
        }
    }
    }

    extension Page.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let title: String
        let excerpt: String
        let content: String
        let imageAssetId: String?
        let createdAt: Date
        let updatedAt: Date
    }
    }

    extension Page.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let title: String
        let excerpt: String
        let imageAssetId: String?
        let createdAt: Date
        let updatedAt: Date
    }
}

extension Page.Table: DatabaseTableWithDelete {}
