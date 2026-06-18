import FeatherOpenAPI
import OpenAPIKit30

struct WebMetadataIdField: StringSchemaRepresentable {
    var example: String? = "metadata_homepage"
}

struct WebMetadataSlugField: StringSchemaRepresentable {
    var example: String? = "homepage"
}

struct WebMetadataReferenceTypeField: StringSchemaRepresentable {
    var example: String? = "web.page"
}

struct WebMetadataReferenceIDField: StringSchemaRepresentable {
    var example: String? = "wp_home"
}

struct WebMetadataTimestampField: DoubleSchemaRepresentable {
    var example: Double? = 1_760_000_000
}

struct WebMetadataNullableTimestampField: SchemaRepresentable {
    var required: Bool = true

    func openAPISchema() -> JSONSchema {
        .number(
            required: required,
            nullable: true,
            deprecated: deprecated,
            title: title,
            description: description
        )
    }
}

struct WebMetadataStatusField: StringSchemaRepresentable {
    var example: String? = "draft"
    var enumValues: [String]? = ["draft", "published", "archived"]
}

struct WebMetadataTitleField: StringSchemaRepresentable {
    var example: String? = "Homepage metadata title"
}

struct WebMetadataExcerptField: StringSchemaRepresentable {
    var example: String? = "Primary metadata description used for the homepage."
}

struct WebMetadataImageURLField: StringSchemaRepresentable {
    var example: String? = "https://example.com/image.jpg"
}

struct WebMetadataNoIndexField: BoolSchemaRepresentable {
    var example: Bool? = false
}

struct WebMetadataPrimaryKeywordField: StringSchemaRepresentable {
    var example: String? = "homepage seo"
}

struct WebMetadataNullableTextField: SchemaRepresentable {
    var required: Bool = true

    func openAPISchema() -> JSONSchema {
        .string(
            required: required,
            nullable: true,
            deprecated: deprecated,
            title: title,
            description: description
        )
    }
}

struct WebMetadataCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "slug": WebMetadataSlugField(),
            "referenceType": WebMetadataReferenceTypeField()
                .reference(required: false),
            "referenceId": WebMetadataReferenceIDField()
                .reference(required: false),
            "publicationDate": WebMetadataNullableTimestampField(
                required: false
            ),
            "expirationDate": WebMetadataNullableTimestampField(
                required: false
            ),
            "status": WebMetadataStatusField(),
            "title": WebMetadataNullableTextField(required: false),
            "excerpt": WebMetadataNullableTextField(required: false),
            "imageUrl": WebMetadataNullableTextField(required: false),
            "canonicalUrl": WebMetadataNullableTextField(required: false),
            "noIndex": WebMetadataNoIndexField().reference(required: false),
            "primaryKeyword": WebMetadataNullableTextField(required: false),
            "cssCodeInjection": WebMetadataNullableTextField(required: false),
            "javascriptCodeInjection": WebMetadataNullableTextField(
                required: false
            ),
            "structuredDataCodeInjection": WebMetadataNullableTextField(
                required: false
            ),
        ]
    }
}

struct WebMetadataPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "slug": WebMetadataSlugField().reference(required: false),
            "referenceType": WebMetadataReferenceTypeField()
                .reference(required: false),
            "referenceId": WebMetadataReferenceIDField()
                .reference(required: false),
            "publicationDate": WebMetadataNullableTimestampField(
                required: false
            ),
            "expirationDate": WebMetadataNullableTimestampField(
                required: false
            ),
            "status": WebMetadataStatusField().reference(required: false),
            "title": WebMetadataNullableTextField(required: false),
            "excerpt": WebMetadataNullableTextField(required: false),
            "imageUrl": WebMetadataNullableTextField(required: false),
            "canonicalUrl": WebMetadataNullableTextField(required: false),
            "noIndex": WebMetadataNoIndexField().reference(required: false),
            "primaryKeyword": WebMetadataNullableTextField(required: false),
            "cssCodeInjection": WebMetadataNullableTextField(required: false),
            "javascriptCodeInjection": WebMetadataNullableTextField(
                required: false
            ),
            "structuredDataCodeInjection": WebMetadataNullableTextField(
                required: false
            ),
        ]
    }
}

struct WebMetadataDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": WebMetadataIdField(),
            "referenceType": WebMetadataReferenceTypeField()
                .reference(required: false),
            "referenceId": WebMetadataReferenceIDField()
                .reference(required: false),
            "slug": WebMetadataSlugField(),
            "publicationDate": WebMetadataNullableTimestampField(
                required: false
            ),
            "expirationDate": WebMetadataNullableTimestampField(
                required: false
            ),
            "status": WebMetadataStatusField(),
            "title": WebMetadataNullableTextField(required: false),
            "excerpt": WebMetadataNullableTextField(required: false),
            "imageUrl": WebMetadataNullableTextField(required: false),
            "canonicalUrl": WebMetadataNullableTextField(required: false),
            "noIndex": WebMetadataNoIndexField(),
            "primaryKeyword": WebMetadataPrimaryKeywordField(),
            "cssCodeInjection": WebMetadataNullableTextField(required: false),
            "javascriptCodeInjection": WebMetadataNullableTextField(
                required: false
            ),
            "structuredDataCodeInjection": WebMetadataNullableTextField(
                required: false
            ),
            "createdAt": WebMetadataTimestampField(),
            "updatedAt": WebMetadataTimestampField(),
        ]
    }
}

struct WebMetadataListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": WebMetadataIdField().reference(),
            "referenceType": WebMetadataReferenceTypeField()
                .reference(required: false),
            "referenceId": WebMetadataReferenceIDField()
                .reference(required: false),
            "slug": WebMetadataSlugField().reference(),
            "publicationDate": WebMetadataNullableTimestampField(
                required: false
            ),
            "expirationDate": WebMetadataNullableTimestampField(
                required: false
            ),
            "status": WebMetadataStatusField().reference(),
            "title": WebMetadataTitleField().reference(),
            "createdAt": WebMetadataTimestampField().reference(),
            "updatedAt": WebMetadataTimestampField().reference(),
        ]
    }
}

struct WebMetadataListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { WebMetadataListItemSchema().reference() }
}
