import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct AdminWebMetadataStatusField: StringSchemaRepresentable {
    var example: String? = "draft"
    var enumValues: [String]? = ["draft", "published", "archived"]
}

struct AdminWebMetadataSlugField: StringSchemaRepresentable {
    var example: String? = "homepage"
}

struct AdminWebMetadataTemplateField: StringSchemaRepresentable {
    var example: String? = "default"
}

struct AdminWebMetadataReferenceTypeField: StringSchemaRepresentable {
    var example: String? = "web.page"
}

struct AdminWebMetadataReferenceIDField: StringSchemaRepresentable {
    var example: String? = "wp_home"
}

struct AdminWebMetadataIdField: StringSchemaRepresentable {
    var example: String? = "metadata_homepage"
}

struct AdminWebMetadataTimestampField: DoubleSchemaRepresentable {
    var example: Double? = 1_760_000_000
}

struct AdminWebMetadataNoIndexField: BoolSchemaRepresentable {
    var example: Bool? = false
}

struct AdminWebMetadataNullableTimestampField: SchemaRepresentable {
    var required: Bool = true

    func openAPISchema() -> JSONSchema {
        .number(required: required, nullable: true)
    }
}

struct AdminWebMetadataNullableTextField: SchemaRepresentable {
    var required: Bool = true

    func openAPISchema() -> JSONSchema {
        .string(required: required, nullable: true)
    }
}

struct AdminWebMetadataPrimaryKeywordField: StringSchemaRepresentable {
    var example: String? = "homepage seo"
}

public struct WebMetadataCreateSchema: ObjectSchemaRepresentable {
    public init() {}
    public var propertyMap: SchemaMap {
        [
            "slug": AdminWebMetadataSlugField(),
            "template": AdminWebMetadataTemplateField()
                .reference(required: false),
            "referenceType": AdminWebMetadataReferenceTypeField()
                .reference(required: false),
            "referenceId": AdminWebMetadataReferenceIDField()
                .reference(required: false),
            "publicationDate": AdminWebMetadataNullableTimestampField(
                required: false
            ),
            "expirationDate": AdminWebMetadataNullableTimestampField(
                required: false
            ),
            "status": AdminWebMetadataStatusField(),
            "title": AdminWebMetadataNullableTextField(required: false),
            "excerpt": AdminWebMetadataNullableTextField(required: false),
            "imageUrl": AdminWebMetadataNullableTextField(required: false),
            "canonicalUrl": AdminWebMetadataNullableTextField(required: false),
            "noIndex": AdminWebMetadataNoIndexField()
                .reference(required: false),
            "primaryKeyword": AdminWebMetadataNullableTextField(
                required: false
            ),
            "cssCodeInjection": AdminWebMetadataNullableTextField(
                required: false
            ),
            "javascriptCodeInjection": AdminWebMetadataNullableTextField(
                required: false
            ),
            "structuredDataCodeInjection": AdminWebMetadataNullableTextField(
                required: false
            ),
        ]
    }
}

public struct WebMetadataPatchSchema: ObjectSchemaRepresentable {
    public init() {}
    public var propertyMap: SchemaMap {
        WebMetadataCreateSchema().propertyMap
    }
}

public struct WebMetadataDetailSchema: ObjectSchemaRepresentable {
    public init() {}
    public var propertyMap: SchemaMap {
        [
            "id": AdminWebMetadataIdField(),
            "referenceType": AdminWebMetadataReferenceTypeField()
                .reference(required: false),
            "referenceId": AdminWebMetadataReferenceIDField()
                .reference(required: false),
            "slug": AdminWebMetadataSlugField(),
            "template": AdminWebMetadataTemplateField(),
            "publicationDate": AdminWebMetadataNullableTimestampField(
                required: false
            ),
            "expirationDate": AdminWebMetadataNullableTimestampField(
                required: false
            ),
            "status": AdminWebMetadataStatusField(),
            "title": AdminWebMetadataNullableTextField(required: false),
            "excerpt": AdminWebMetadataNullableTextField(required: false),
            "imageUrl": AdminWebMetadataNullableTextField(required: false),
            "canonicalUrl": AdminWebMetadataNullableTextField(required: false),
            "noIndex": AdminWebMetadataNoIndexField(),
            "primaryKeyword": AdminWebMetadataPrimaryKeywordField(),
            "cssCodeInjection": AdminWebMetadataNullableTextField(
                required: false
            ),
            "javascriptCodeInjection": AdminWebMetadataNullableTextField(
                required: false
            ),
            "structuredDataCodeInjection": AdminWebMetadataNullableTextField(
                required: false
            ),
            "createdAt": AdminWebMetadataTimestampField(),
            "updatedAt": AdminWebMetadataTimestampField(),
        ]
    }
}
