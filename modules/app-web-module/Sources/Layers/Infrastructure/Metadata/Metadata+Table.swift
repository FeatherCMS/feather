import FeatherDBAL
import WebDomain

import struct Foundation.Date

extension Metadata {
    struct Table: DatabaseTable {
        static let name = "web_metadata"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let id = DatabaseTableColumn<String>(name: "id")
            let referenceType = DatabaseTableColumn<String>(
                name: "reference_type"
            )
            let referenceID = DatabaseTableColumn<String>(name: "reference_id")
            let template = DatabaseTableColumn<String>(name: "template")
            let slug = DatabaseTableColumn<String>(name: "slug")
            let publicationDate = DatabaseTableColumn<Date>(
                name: "publication_date"
            )
            let expirationDate = DatabaseTableColumn<Date?>(
                name: "expiration_date"
            )
            let status = DatabaseTableColumn<String>(name: "status")
            let titleOverride = DatabaseTableColumn<String?>(
                name: "title_override"
            )
            let excerptOverride = DatabaseTableColumn<String?>(
                name: "excerpt_override"
            )
            let imageURLOverride = DatabaseTableColumn<String?>(
                name: "image_url_override"
            )
            let canonicalURL = DatabaseTableColumn<String?>(
                name: "canonical_url"
            )
            let noIndex = DatabaseTableColumn<Bool>(name: "no_index")
            let primaryKeyword = DatabaseTableColumn<String?>(
                name: "primary_keyword"
            )
            let cssCodeInjection = DatabaseTableColumn<String?>(
                name: "css_code_injection"
            )
            let javascriptCodeInjection = DatabaseTableColumn<String?>(
                name: "javascript_code_injection"
            )
            let structuredDataCodeInjection = DatabaseTableColumn<String?>(
                name: "structured_data_code_injection"
            )
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
