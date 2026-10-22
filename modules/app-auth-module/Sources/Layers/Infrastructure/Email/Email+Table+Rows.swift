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
    }
}

extension Email.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let identityId: String
        let email: String
        let createdAt: Date
        let updatedAt: Date
    }
}

extension Email.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let identityId: String
        let email: String
    }
}

extension Email.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let identityId: String
        let email: String

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Email.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension Email.Table: DatabaseTableWithDelete {}
