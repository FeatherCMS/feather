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
        let templateData: String?
        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Metadata.Table.columns.publicationDate] = .value(
                publicationDate
            )
            if let expirationDate {
                values[Metadata.Table.columns.expirationDate] = .value(
                    expirationDate
                )
            }
            else {
                values[Metadata.Table.columns.expirationDate] = .null
            }
        }

        enum CodingKeys: String, CodingKey {
            case id
            case referenceType = "reference_type"
            case referenceID = "reference_id"
            case template
            case slug
            case publicationDate = "publication_date"
            case expirationDate = "expiration_date"
            case status
            case titleOverride = "title_override"
            case excerptOverride = "excerpt_override"
            case imageURLOverride = "image_url_override"
            case canonicalURL = "canonical_url"
            case noIndex = "no_index"
            case primaryKeyword = "primary_keyword"
            case cssCodeInjection = "css_code_injection"
            case javascriptCodeInjection = "javascript_code_injection"
            case structuredDataCodeInjection = "structured_data_code_injection"
            case templateData = "template_data"
        }
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
        let templateData: String?

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Metadata.Table.columns.updatedAt] = .currentTimestamp

            values[Metadata.Table.columns.publicationDate] = .value(
                publicationDate
            )
            if let expirationDate {
                values[Metadata.Table.columns.expirationDate] = .value(
                    expirationDate
                )
            }
            else {
                values[Metadata.Table.columns.expirationDate] = .null
            }
        }

        enum CodingKeys: String, CodingKey {
            case referenceType = "reference_type"
            case referenceID = "reference_id"
            case template
            case slug
            case publicationDate = "publication_date"
            case expirationDate = "expiration_date"
            case status
            case titleOverride = "title_override"
            case excerptOverride = "excerpt_override"
            case imageURLOverride = "image_url_override"
            case canonicalURL = "canonical_url"
            case noIndex = "no_index"
            case primaryKeyword = "primary_keyword"
            case cssCodeInjection = "css_code_injection"
            case javascriptCodeInjection = "javascript_code_injection"
            case structuredDataCodeInjection = "structured_data_code_injection"
            case templateData = "template_data"
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
        let templateData: String?
        let createdAt: Date
        let updatedAt: Date

        enum CodingKeys: String, CodingKey {
            case id
            case referenceType = "reference_type"
            case referenceID = "reference_id"
            case template
            case slug
            case publicationDate = "publication_date"
            case expirationDate = "expiration_date"
            case status
            case titleOverride = "title_override"
            case excerptOverride = "excerpt_override"
            case imageURLOverride = "image_url_override"
            case canonicalURL = "canonical_url"
            case noIndex = "no_index"
            case primaryKeyword = "primary_keyword"
            case cssCodeInjection = "css_code_injection"
            case javascriptCodeInjection = "javascript_code_injection"
            case structuredDataCodeInjection = "structured_data_code_injection"
            case templateData = "template_data"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
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

        enum CodingKeys: String, CodingKey {
            case id
            case referenceType = "reference_type"
            case referenceID = "reference_id"
            case slug
            case publicationDate = "publication_date"
            case expirationDate = "expiration_date"
            case status
            case titleOverride = "title_override"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension Metadata.Table: DatabaseTableWithDelete {}
