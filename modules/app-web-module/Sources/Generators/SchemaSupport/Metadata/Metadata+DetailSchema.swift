public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct MetadataIdField: StringSchemaRepresentable {
    public init() {}
    public var example: String? = "metadata_homepage"
}

public struct MetadataNullableTimestampField: SchemaRepresentable {
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

public struct MetadataPrimaryKeywordField: StringSchemaRepresentable {
    public init() {}
    public var example: String? = "homepage seo"
}

public struct MetadataNullableTextField: SchemaRepresentable {
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

public struct MetadataDetailSchema: ObjectSchemaRepresentable {
    public init() {}

    public var propertyMap: SchemaMap {
        [
            "id": MetadataIdField(),
            "referenceType": MetadataReferenceTypeField()
                .reference(required: false),
            "referenceId": MetadataReferenceIDField()
                .reference(required: false),
            "slug": MetadataSlugField(),
            "template": MetadataTemplateField(),
            "publicationDate": MetadataNullableTimestampField(
                required: false
            ),
            "expirationDate": MetadataNullableTimestampField(
                required: false
            ),
            "status": MetadataStatusField(),
            "availability": MetadataAvailabilityField().reference(),
            "title": MetadataNullableTextField(required: false),
            "excerpt": MetadataNullableTextField(required: false),
            "imageUrl": MetadataNullableTextField(required: false),
            "canonicalUrl": MetadataNullableTextField(required: false),
            "noIndex": MetadataNoIndexField(),
            "primaryKeyword": MetadataPrimaryKeywordField(),
            "cssCodeInjection": MetadataNullableTextField(required: false),
            "javascriptCodeInjection": MetadataNullableTextField(
                required: false
            ),
            "structuredDataCodeInjection": MetadataNullableTextField(
                required: false
            ),
            "createdAt": MetadataTimestampField(),
            "updatedAt": MetadataTimestampField(),
        ]
    }
}
