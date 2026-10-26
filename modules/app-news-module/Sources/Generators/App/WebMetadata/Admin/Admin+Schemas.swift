import FeatherOpenAPI
import OpenAPIKit30

extension WebMetadata.Admin {
    enum Schemas {}
}

extension WebMetadata.Admin.Schemas {
    struct Status: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AdminWebMetadataStatusField" }
        var example: String? = "draft"
        var enumValues: [String]? = ["draft", "published", "archived"]
    }

    struct Slug: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AdminWebMetadataSlugField" }
        var example: String? = "homepage"
    }

    struct Template: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AdminWebMetadataTemplateField" }
        var example: String? = "default"
    }

    struct ReferenceType: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AdminWebMetadataReferenceTypeField" }
        var example: String? = "web.page"
    }

    struct ReferenceID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AdminWebMetadataReferenceIDField" }
        var example: String? = "wp_home"
    }

    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AdminWebMetadataIdField" }
        var example: String? = "metadata_homepage"
    }

    struct Timestamp: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "AdminWebMetadataTimestampField" }
        var example: Double? = 1_760_000_000
    }

    struct NoIndex: BoolSchemaRepresentable {
        var openAPIIdentifier: String { "AdminWebMetadataNoIndexField" }
        var example: Bool? = false
    }

    struct NullableTimestamp: SchemaRepresentable {
        var required: Bool = true

        init(required: Bool = true) {
            self.required = required
        }

        func openAPISchema() -> JSONSchema {
            .number(required: required, nullable: true)
        }
    }

    struct NullableText: SchemaRepresentable {
        var required: Bool = true

        init(required: Bool = true) {
            self.required = required
        }

        func openAPISchema() -> JSONSchema {
            .string(required: required, nullable: true)
        }
    }

    struct PrimaryKeyword: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AdminWebMetadataPrimaryKeywordField" }
        var example: String? = "homepage seo"
    }
}
