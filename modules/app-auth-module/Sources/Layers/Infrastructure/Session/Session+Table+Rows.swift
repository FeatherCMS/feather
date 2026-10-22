import AuthModule
import FeatherDBAL
import Foundation

extension Session.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let token: String
        let identityId: String
        let authenticationType: String
        let authenticationReference: String
        let isPersistent: Bool
        let createdAt: Date
        let updatedAt: Date
        let expiresAt: Date
    }
    }

    extension Session.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let token: String
        let identityId: String
        let authenticationType: String
        let authenticationReference: String
        let isPersistent: Bool
        let createdAt: Date
        let updatedAt: Date
        let expiresAt: Date
    }
    }

    extension Session.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let token: String
        let identityId: String
        let authenticationType: String
        let authenticationReference: String
        let isPersistent: Bool
        let expiresAt: Date
    }
    }

    extension Session.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let token: String
        let identityId: String
        let authenticationType: String
        let authenticationReference: String
        let isPersistent: Bool
        let expiresAt: Date

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Session.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension Session.Table: DatabaseTableWithDelete {}
