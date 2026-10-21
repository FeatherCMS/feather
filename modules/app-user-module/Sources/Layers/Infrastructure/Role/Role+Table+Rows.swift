import FeatherDBAL
import Foundation
import UserModule

extension Role.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let key: String
        let name: String?
        let notes: String?
        let createdAt: Date
        let updatedAt: Date
    }
}

extension Role.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let key: String
        let name: String?
        let notes: String?
        let createdAt: Date
        let updatedAt: Date
    }
}

extension Role.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let key: String
        let name: String?
        let notes: String?
    }
}

extension Role.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let key: String
        let name: String?
        let notes: String?

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Role.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension Role.Table: DatabaseTableWithDelete {}
