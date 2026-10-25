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

        enum CodingKeys: String, CodingKey {
            case id
            case variantId = "variant_id"
            case name
            case matchExtensions = "match_extensions"
            case commandTemplate = "command_template"
            case isActive = "is_active"
        }
    }
}

extension Variant.Processor.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let name: String
        let matchExtensions: String
        let commandTemplate: String
        let isActive: Bool

        enum CodingKeys: String, CodingKey {
            case name
            case matchExtensions = "match_extensions"
            case commandTemplate = "command_template"
            case isActive = "is_active"
        }

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
