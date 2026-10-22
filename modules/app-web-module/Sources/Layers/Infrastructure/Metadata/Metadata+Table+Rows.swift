import FeatherDBAL
import WebDomain
import WebModule

import struct Foundation.Date

extension Metadata.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let referenceType: String
        let referenceID: String
        let template: String
        let slug: String
        let publicationDate: Date
        let expirationDate: Date?
        let status: String
        let titleOverride: String?
        let excerptOverride: String?
        let imageURLOverride: String?
        let canonicalURL: String?
        let noIndex: Bool
        let primaryKeyword: String?
        let cssCodeInjection: String?
        let javascriptCodeInjection: String?
        let structuredDataCodeInjection: String?
    }
}

extension Metadata.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let referenceType: String
        let referenceID: String
        let template: String
        let slug: String
        let publicationDate: Date
        let expirationDate: Date?
        let status: String
        let titleOverride: String?
        let excerptOverride: String?
        let imageURLOverride: String?
        let canonicalURL: String?
        let noIndex: Bool
        let primaryKeyword: String?
        let cssCodeInjection: String?
        let javascriptCodeInjection: String?
        let structuredDataCodeInjection: String?

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Metadata.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension Metadata.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let referenceType: String
        let referenceID: String
        let template: String
        let slug: String
        let publicationDate: Date
        let expirationDate: Date?
        let status: String
        let titleOverride: String?
        let excerptOverride: String?
        let imageURLOverride: String?
        let canonicalURL: String?
        let noIndex: Bool
        let primaryKeyword: String?
        let cssCodeInjection: String?
        let javascriptCodeInjection: String?
        let structuredDataCodeInjection: String?
        let createdAt: Date
        let updatedAt: Date
    }
}

extension Metadata.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let referenceType: String
        let referenceID: String
        let slug: String
        let publicationDate: Date
        let expirationDate: Date?
        let status: String
        let titleOverride: String?
        let createdAt: Date
        let updatedAt: Date
    }
}

extension Metadata.Table: DatabaseTableWithDelete {}
