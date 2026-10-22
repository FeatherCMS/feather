import AuthModule
import FeatherDBAL
import Foundation

extension Credential.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let authEmailId: String
        let passwordHash: String
    }
}

extension Credential.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let authEmailId: String
        let passwordHash: String

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Credential.Table.columns.updatedAt] = .currentTimestamp
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
