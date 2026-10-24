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
    }
}

extension Rule.Table: DatabaseTableWithDelete {}
