import FeatherDBAL
import Foundation
import RedirectModule

extension RedirectModule.Rule.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let source: String
        let destination: String
        let statusCode: Int
        let notes: String?
    }
}

extension RedirectModule.Rule.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let source: String
        let destination: String
        let statusCode: Int
        let notes: String?

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[RedirectModule.Rule.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension RedirectModule.Rule.Table: DatabaseTableWithDetail {
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

extension RedirectModule.Rule.Table: DatabaseTableWithList {
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

extension RedirectModule.Rule.Table: DatabaseTableWithDelete {}
