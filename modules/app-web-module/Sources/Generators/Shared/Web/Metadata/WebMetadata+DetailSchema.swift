import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public struct WebMetadataIdField: StringSchemaRepresentable {
    public init() {}
    public var example: String? = "metadata_homepage"
}

public struct WebMetadataNullableTimestampField: SchemaRepresentable {
    public var required: Bool = true

    public init(required: Bool = true) {
        self.required = required
    }

    public func openAPISchema() -> JSONSchema {
        .number(
            required: required,
            nullable: true,
            deprecated: deprecated,
            title: title,
            description: description
        )
    }
}

public struct WebMetadataPrimaryKeywordField: StringSchemaRepresentable {
    public init() {}
    public var example: String? = "homepage seo"
}

public struct WebMetadataNullableTextField: SchemaRepresentable {
    public var required: Bool = true

    public init(required: Bool = true) {
        self.required = required
    }

    public func openAPISchema() -> JSONSchema {
        .string(
            required: required,
            nullable: true,
            deprecated: deprecated,
            title: title,
            description: description
        )
    }
}

public struct WebMetadataDetailSchema: ObjectSchemaRepresentable {
    public init() {}

    public var propertyMap: SchemaMap {
        [
            "id": WebMetadataIdField(),
            "referenceType": WebMetadataReferenceTypeField()
                .reference(required: false),
            "referenceId": WebMetadataReferenceIDField()
                .reference(required: false),
            "slug": WebMetadataSlugField(),
            "template": WebMetadataTemplateField(),
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
