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
        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[MagicLink.Table.columns.expiresAt] = .value(expiresAt)
        }

        enum CodingKeys: String, CodingKey {
            case id
            case authEmailId = "auth_email_id"
            case token
            case expiresAt = "expires_at"
            case isPersistent = "is_persistent"
        }
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

            values[MagicLink.Table.columns.expiresAt] = .value(expiresAt)
        }

        enum CodingKeys: String, CodingKey {
            case authEmailId = "auth_email_id"
            case token
            case expiresAt = "expires_at"
            case isPersistent = "is_persistent"
            case isUsed = "is_used"
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

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case authEmailId = "auth_email_id"
            case token = "token"
            case expiresAt = "expires_at"
            case isPersistent = "is_persistent"
            case isUsed = "is_used"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension MagicLink.Table: DatabaseTableWithDelete {}
