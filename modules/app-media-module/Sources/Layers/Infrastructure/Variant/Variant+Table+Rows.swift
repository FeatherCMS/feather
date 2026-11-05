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

        enum CodingKeys: String, CodingKey {
            case id
            case key = "variant_key"
            case name
            case isRequired = "is_required"
            case isActive = "is_active"
        }
    }
}

extension Variant.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let key: String
        let name: String
        let isRequired: Bool
        let isActive: Bool

        enum CodingKeys: String, CodingKey {
            case key = "variant_key"
            case name
            case isRequired = "is_required"
            case isActive = "is_active"
        }

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
        enum CodingKeys: String, CodingKey {
            case id
            case key = "variant_key"
            case name
            case isRequired = "is_required"
            case isActive = "is_active"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
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
        enum CodingKeys: String, CodingKey {
            case id
            case key = "variant_key"
            case name
            case isRequired = "is_required"
            case isActive = "is_active"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension Variant.Table: DatabaseTableWithDelete {}
