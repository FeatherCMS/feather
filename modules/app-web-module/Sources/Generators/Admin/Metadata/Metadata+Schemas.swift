public import FeatherOpenAPI
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public struct MetadataSlugField: StringSchemaRepresentable {
    public init() {}
    public var example: String? = "homepage"
}

public struct MetadataTemplateField: StringSchemaRepresentable {
    public init() {}
    public var example: String? = "default"
}

public struct MetadataReferenceTypeField: StringSchemaRepresentable {
    public init() {}
    public var example: String? = "web.page"
}

public struct MetadataReferenceIDField: StringSchemaRepresentable {
    public init() {}
    public var example: String? = "wp_home"
}

public struct MetadataTimestampField: DoubleSchemaRepresentable {
    public init() {}
    public var example: Double? = 1_760_000_000
}

public struct MetadataStatusField: StringSchemaRepresentable {
    public init() {}
    public var example: String? = "draft"
    public var enumValues: [String]? = ["draft", "published", "archived"]
}

public struct MetadataTitleField: StringSchemaRepresentable {
    public init() {}
    public var example: String? = "Homepage metadata title"
}

public struct MetadataExcerptField: StringSchemaRepresentable {
    public init() {}
    public var example: String? =
        "Primary metadata description used for the homepage."
}

public struct MetadataImageURLField: StringSchemaRepresentable {
    public init() {}
    public var example: String? = "https://example.com/image.jpg"
}

public struct MetadataNoIndexField: BoolSchemaRepresentable {
    public init() {}
    public var example: Bool? = false
}

public struct MetadataCreateSchema: ObjectSchemaRepresentable {
    public init() {}
    public var propertyMap: SchemaMap {
        [
            "slug": MetadataSlugField(),
            "template": MetadataTemplateField().reference(required: false),
            "referenceType": MetadataReferenceTypeField()
                .reference(required: false),
            "referenceId": MetadataReferenceIDField()
                .reference(required: false),
            "publicationDate": MetadataNullableTimestampField(
                required: false
            ),
            "expirationDate": MetadataNullableTimestampField(
                required: false
            ),
            "status": MetadataStatusField(),
            "title": MetadataNullableTextField(required: false),
            "excerpt": MetadataNullableTextField(required: false),
            "imageUrl": MetadataNullableTextField(required: false),
            "canonicalUrl": MetadataNullableTextField(required: false),
            "noIndex": MetadataNoIndexField().reference(required: false),
            "primaryKeyword": MetadataNullableTextField(required: false),
            "cssCodeInjection": MetadataNullableTextField(required: false),
            "javascriptCodeInjection": MetadataNullableTextField(
                required: false
            ),
            "structuredDataCodeInjection": MetadataNullableTextField(
                required: false
            ),
        ]
    }
}

public struct MetadataPatchSchema: ObjectSchemaRepresentable {
    public init() {}
    public var propertyMap: SchemaMap {
        [
            "slug": MetadataSlugField().reference(required: false),
            "template": MetadataTemplateField().reference(required: false),
            "referenceType": MetadataReferenceTypeField()
                .reference(required: false),
            "referenceId": MetadataReferenceIDField()
                .reference(required: false),
            "publicationDate": MetadataNullableTimestampField(
                required: false
            ),
            "expirationDate": MetadataNullableTimestampField(
                required: false
            ),
            "status": MetadataStatusField().reference(required: false),
            "title": MetadataNullableTextField(required: false),
            "excerpt": MetadataNullableTextField(required: false),
            "imageUrl": MetadataNullableTextField(required: false),
            "canonicalUrl": MetadataNullableTextField(required: false),
            "noIndex": MetadataNoIndexField().reference(required: false),
            "primaryKeyword": MetadataNullableTextField(required: false),
            "cssCodeInjection": MetadataNullableTextField(required: false),
            "javascriptCodeInjection": MetadataNullableTextField(
                required: false
            ),
            "structuredDataCodeInjection": MetadataNullableTextField(
                required: false
            ),
        ]
    }
}

public struct MetadataReferenceIDsSchema: ArraySchemaRepresentable {
    public init() {}
    public var items: (any SchemaRepresentable)? {
        MetadataReferenceIDField()
    }
}

public struct MetadataResolveRequestSchema: ObjectSchemaRepresentable {
    public init() {}
    public var propertyMap: SchemaMap {
        [
            "referenceType": MetadataReferenceTypeField(),
            "referenceIds": MetadataReferenceIDsSchema(),
        ]
    }
}

public struct MetadataResolveItemSchema: ObjectSchemaRepresentable {
    public init() {}
    public var propertyMap: SchemaMap {
        [
            "referenceId": MetadataReferenceIDField(),
            "slug": MetadataSlugField(),
            "publicationDate": MetadataTimestampField(),
            "expirationDate": MetadataNullableTimestampField(
                required: false
            ),
            "status": MetadataStatusField(),
            "availability": MetadataAvailabilityField().reference(),
        ]
    }
}

public struct MetadataResolveSchema: ArraySchemaRepresentable {
    public init() {}
    public var items: (any SchemaRepresentable)? {
        MetadataResolveItemSchema().reference()
    }
}

public struct MetadataListItemSchema: ObjectSchemaRepresentable {
    public init() {}
    public var propertyMap: SchemaMap {
        [
            "id": MetadataIdField().reference(),
            "referenceType": MetadataReferenceTypeField()
                .reference(required: false),
            "referenceId": MetadataReferenceIDField()
                .reference(required: false),
            "slug": MetadataSlugField().reference(),
            "publicationDate": MetadataNullableTimestampField(
                required: false
            ),
            "expirationDate": MetadataNullableTimestampField(
                required: false
            ),
            "status": MetadataStatusField().reference(),
            "availability": MetadataAvailabilityField().reference(),
            "title": MetadataTitleField().reference(),
            "createdAt": MetadataTimestampField().reference(),
            "updatedAt": MetadataTimestampField().reference(),
        ]
    }
}

public struct MetadataListSchema: ArraySchemaRepresentable {
    public init() {}
    public var items: (any SchemaRepresentable)? {
        MetadataListItemSchema().reference()
    }
}

public struct MetadataQueryItemSchema: ObjectSchemaRepresentable {
    public init() {}
    public var propertyMap: SchemaMap {
        [
            "id": MetadataIdField().reference(),
            "referenceType": MetadataReferenceTypeField()
                .reference(required: false),
            "referenceId": MetadataReferenceIDField()
                .reference(required: false),
            "slug": MetadataSlugField().reference(),
            "publicationDate": MetadataNullableTimestampField(
                required: false
            ),
            "expirationDate": MetadataNullableTimestampField(
                required: false
            ),
            "status": MetadataStatusField().reference(),
            "availability": MetadataAvailabilityField().reference(),
            "title": MetadataTitleField().reference(),
            "createdAt": MetadataTimestampField().reference(),
            "updatedAt": MetadataTimestampField().reference(),
        ]
    }
}
