import FeatherDBAL
import Foundation
import MediaModule

extension Variant.Processor.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let variantId: String
        let name: String
        let matchExtensions: String
        let commandTemplate: String
        let isActive: Bool
    }
}

extension Variant.Processor.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let name: String
        let matchExtensions: String
        let commandTemplate: String
        let isActive: Bool

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Variant.Processor.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension Variant.Processor.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let variantId: String
        let name: String
        let matchExtensions: String
        let commandTemplate: String
        let isActive: Bool
        let createdAt: Date
        let updatedAt: Date
    }
}

extension Variant.Processor.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let variantId: String
        let name: String
        let matchExtensions: String
        let commandTemplate: String
        let isActive: Bool
        let createdAt: Date
        let updatedAt: Date
    }
}

extension Variant.Processor.Table: DatabaseTableWithDelete {}
