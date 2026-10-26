import AuthModule
import FeatherDBAL
import Foundation

extension Email.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let identityId: String
        let email: String
        let createdAt: Date
        let updatedAt: Date

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case identityId = "identity_id"
            case email = "email"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension Email.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let identityId: String
        let email: String
        let createdAt: Date
        let updatedAt: Date

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case identityId = "identity_id"
            case email = "email"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension Email.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let identityId: String
        let email: String

        enum CodingKeys: String, CodingKey {
            case id
            case identityId = "identity_id"
            case email
        }
    }
}

extension Email.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let identityId: String
        let email: String

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Email.Table.columns.updatedAt] = .currentTimestamp
        }

        enum CodingKeys: String, CodingKey {
            case identityId = "identity_id"
            case email
        }
    }
}

extension Email.Table: DatabaseTableWithDelete {}
