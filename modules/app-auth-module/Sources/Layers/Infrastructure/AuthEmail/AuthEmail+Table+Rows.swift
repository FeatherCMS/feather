import AuthModule
import FeatherDBAL
import Foundation

extension AuthEmail.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let identityId: String
        let email: String
        let createdAt: Date
        let updatedAt: Date
    }
}

extension AuthEmail.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let identityId: String
        let email: String
        let createdAt: Date
        let updatedAt: Date
    }
}

extension AuthEmail.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let identityId: String
        let email: String
    }
}

extension AuthEmail.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let identityId: String
        let email: String

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[AuthEmail.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension AuthEmail.Table: DatabaseTableWithDelete {}
