import AuthModule
import FeatherDBAL
import Foundation

extension Credential.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let authEmailId: String
        let passwordHash: String

        enum CodingKeys: String, CodingKey {
            case id
            case authEmailId = "auth_email_id"
            case passwordHash = "password_hash"
        }
    }
}

extension Credential.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let authEmailId: String
        let passwordHash: String

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Credential.Table.columns.updatedAt] = .currentTimestamp
        }

        enum CodingKeys: String, CodingKey {
            case authEmailId = "auth_email_id"
            case passwordHash = "password_hash"
        }
    }
}

extension Credential.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let authEmailId: String
        let passwordHash: String
        let createdAt: Date
        let updatedAt: Date
    }
}

extension Credential.Table: DatabaseTableWithDelete {}
