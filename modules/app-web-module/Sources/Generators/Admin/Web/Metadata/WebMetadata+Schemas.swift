import FeatherOpenAPI
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public struct WebMetadataSlugField: StringSchemaRepresentable {
    public init() {}
    public var example: String? = "homepage"
}

public struct WebMetadataTemplateField: StringSchemaRepresentable {
    public init() {}
    public var example: String? = "default"
}

public struct WebMetadataReferenceTypeField: StringSchemaRepresentable {
    public init() {}
    public var example: String? = "web.page"
}

public struct WebMetadataReferenceIDField: StringSchemaRepresentable {
    public init() {}
    public var example: String? = "wp_home"
}

public struct WebMetadataTimestampField: DoubleSchemaRepresentable {
    public init() {}
    public var example: Double? = 1_760_000_000
}

public struct WebMetadataStatusField: StringSchemaRepresentable {
    public init() {}
    public var example: String? = "draft"
    public var enumValues: [String]? = ["draft", "published", "archived"]
}

public struct WebMetadataTitleField: StringSchemaRepresentable {
    public init() {}
    public var example: String? = "Homepage metadata title"
}

public struct WebMetadataExcerptField: StringSchemaRepresentable {
    public init() {}
    public var example: String? =
        "Primary metadata description used for the homepage."
}

public struct WebMetadataImageURLField: StringSchemaRepresentable {
    public init() {}
    public var example: String? = "https://example.com/image.jpg"
}

public struct WebMetadataNoIndexField: BoolSchemaRepresentable {
    public init() {}
    public var example: Bool? = false
}

public struct WebMetadataCreateSchema: ObjectSchemaRepresentable {
    public init() {}
    public var propertyMap: SchemaMap {
        [
            "slug": WebMetadataSlugField(),
            "template": WebMetadataTemplateField().reference(required: false),
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

public struct WebMetadataPatchSchema: ObjectSchemaRepresentable {
    public init() {}
    public var propertyMap: SchemaMap {
        [
            "slug": WebMetadataSlugField().reference(required: false),
            "template": WebMetadataTemplateField().reference(required: false),
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

public struct WebMetadataListItemSchema: ObjectSchemaRepresentable {
    public init() {}
    public var propertyMap: SchemaMap {
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

public struct WebMetadataListSchema: ArraySchemaRepresentable {
    public init() {}
    public var items: SchemaRepresentable? {
        WebMetadataListItemSchema().reference()
    }
}
