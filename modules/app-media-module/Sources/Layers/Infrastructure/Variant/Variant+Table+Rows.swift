import FeatherDBAL
import Foundation
import MediaModule

extension Variant.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let key: String
        let name: String
        let isRequired: Bool
        let isActive: Bool
    }
}

extension Variant.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let key: String
        let name: String
        let isRequired: Bool
        let isActive: Bool

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Variant.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension Variant.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let key: String
        let name: String
        let isRequired: Bool
        let isActive: Bool
        let createdAt: Date
        let updatedAt: Date
    }
}

extension Variant.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let key: String
        let name: String
        let isRequired: Bool
        let isActive: Bool
        let createdAt: Date
        let updatedAt: Date
    }
}

extension Variant.Table: DatabaseTableWithDelete {}
