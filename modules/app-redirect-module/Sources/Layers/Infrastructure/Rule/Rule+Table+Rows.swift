import FeatherDBAL
import Foundation
import RedirectModule

extension Rule.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let source: String
        let destination: String
        let statusCode: Int
        let notes: String?

        enum CodingKeys: String, CodingKey {
            case id
            case source
            case destination
            case statusCode = "status_code"
            case notes
        }
    }
}

extension Rule.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let source: String
        let destination: String
        let statusCode: Int
        let notes: String?

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Rule.Table.columns.updatedAt] = .currentTimestamp
        }

        enum CodingKeys: String, CodingKey {
            case source
            case destination
            case statusCode = "status_code"
            case notes
        }
    }
}

extension Rule.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let source: String
        let destination: String
        let statusCode: Int
        let notes: String?
        let createdAt: Date
        let updatedAt: Date

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case source = "source"
            case destination = "destination"
            case statusCode = "status_code"
            case notes = "notes"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension Rule.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let source: String
        let destination: String
        let statusCode: Int
        let notes: String?
        let createdAt: Date
        let updatedAt: Date

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case source = "source"
            case destination = "destination"
            case statusCode = "status_code"
            case notes = "notes"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension Rule.Table: DatabaseTableWithDelete {}
