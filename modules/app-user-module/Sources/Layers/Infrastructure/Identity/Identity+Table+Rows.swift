import FeatherDBAL
import Foundation
import UserModule

extension Identity.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let name: String
        let status: String
        let isRoot: Bool
        let createdAt: Date
        let updatedAt: Date
    }
}

extension Identity.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let name: String
        let status: String
        let isRoot: Bool
        let createdAt: Date
        let updatedAt: Date
    }
}

extension Identity.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let name: String
        let status: String
        let isRoot: Bool
    }
}

extension Identity.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let id: String
        let name: String
        let status: String
        let isRoot: Bool

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Identity.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension Identity.Table: DatabaseTableWithDelete {}

extension Identity.Table.RoleLink: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let roleId: String
        let identityId: String
    }
}

extension Identity.Table.RoleLink: DatabaseTableWithDelete {}
