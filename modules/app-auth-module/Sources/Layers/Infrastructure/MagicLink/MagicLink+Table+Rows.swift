import AuthModule
import FeatherDBAL
import Foundation

extension MagicLink.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let authEmailId: String
        let token: String
        let expiresAt: Date
        let isPersistent: Bool
    }
    }

    extension MagicLink.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let authEmailId: String
        let token: String
        let expiresAt: Date
        let isPersistent: Bool
        let isUsed: Bool

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[MagicLink.Table.columns.updatedAt] = .currentTimestamp
        }
    }
    }

    extension MagicLink.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let authEmailId: String
        let token: String
        let expiresAt: Date
        let isPersistent: Bool
        let isUsed: Bool
        let createdAt: Date
        let updatedAt: Date
    }
}

extension MagicLink.Table: DatabaseTableWithDelete {}
