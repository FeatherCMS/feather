import AccountModule
import FeatherDBAL
import Foundation

extension Invitation.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let userId: String
        let email: String
        let token: String
        let roleIds: String
        let expiresAt: Date
        let createdAt: Date
        let updatedAt: Date
    }
    }

    extension Invitation.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let userId: String
        let email: String
        let token: String
        let roleIds: String
        let expiresAt: Date
        let createdAt: Date
        let updatedAt: Date
    }
    }

    extension Invitation.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let userId: String
        let email: String
        let token: String
        let roleIds: String
        let expiresAt: Date
    }
    }

    extension Invitation.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let userId: String
        let email: String
        let token: String
        let roleIds: String
        let expiresAt: Date

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Invitation.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension Invitation.Table: DatabaseTableWithDelete {}
