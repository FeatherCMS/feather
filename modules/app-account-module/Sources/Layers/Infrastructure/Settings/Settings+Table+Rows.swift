import AccountModule
import FeatherDBAL
import Foundation

extension Settings.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let userId: String
        let language: String
        let timezone: String
        let pageSize: Int
        let createdAt: Date
        let updatedAt: Date
    }
}

extension Settings.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let userId: String
        let language: String
        let timezone: String
        let pageSize: Int

        enum CodingKeys: String, CodingKey {
            case id
            case userId = "user_id"
            case language
            case timezone
            case pageSize = "page_size"
        }
    }
}

extension Settings.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let language: String
        let timezone: String
        let pageSize: Int

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Settings.Table.columns.updatedAt] = .currentTimestamp
        }

        enum CodingKeys: String, CodingKey {
            case language
            case timezone
            case pageSize = "page_size"
        }
    }
}

extension Settings.Table: DatabaseTableWithDelete {}
