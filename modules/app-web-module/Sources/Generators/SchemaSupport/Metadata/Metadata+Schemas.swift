public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public struct MetadataSlugField: StringSchemaRepresentable {
    public var example: String? = "homepage"

    public init() {}
}

public struct MetadataSlugListSchema: ArraySchemaRepresentable {
    public var items: (any SchemaRepresentable)? {
        MetadataSlugField().reference()
    }

    public init() {}
}

public struct MetadataTemplateField: StringSchemaRepresentable {
    public var example: String? = "default"

    public init() {}
}

public struct MetadataPathField: StringSchemaRepresentable {
    public var example: String? = "blog"

    public init() {}
}

public struct MetadataReferenceTypeField: StringSchemaRepresentable {
    public var example: String? = "web.page"

    public init() {}
}

public struct MetadataReferenceIDField: StringSchemaRepresentable {
    public var example: String? = "wp_home"

    public init() {}
}

public struct MetadataTimestampField: DoubleSchemaRepresentable {
    public var example: Double? { 1_760_000_000 }

    public init() {}
}

public struct MetadataStatusField: StringSchemaRepresentable {
    public var enumValues: [String]? = ["draft", "published", "archived"]
    public var example: String? = "published"

    public init() {}
}

public struct MetadataAvailabilityField: StringSchemaRepresentable {
    public var allowedValues: [String]? = [
        "draft", "scheduled", "live", "expired", "archived",
    ]
    public var example: String? = "live"

    public init() {}
}

public struct MetadataTitleField: StringSchemaRepresentable {
    public var example: String? = "Hello world"

    public init() {}
}

public struct MetadataExcerptField: StringSchemaRepresentable {
    public var example: String? = "Short summary"

    public init() {}
}

public struct MetadataImageURLField: StringSchemaRepresentable {
    public var example: String? = "/public/12/34/56789/originals/example.png"

    public init() {}
}

public struct MetadataCanonicalURLField: StringSchemaRepresentable {
    public var example: String? = "https://example.com/posts/hello-world"

    public init() {}
}

public struct MetadataNoIndexField: BoolSchemaRepresentable {
    public var example: Bool? = false

    public init() {}
}

public struct MetadataCodeInjectionField: StringSchemaRepresentable {
    public var example: String? = "<p>Hello world</p>"

    public init() {}
}

public struct MetadataSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "referenceType": MetadataReferenceTypeField().reference(),
            "referenceId": MetadataReferenceIDField().reference(),
            "slug": MetadataSlugField().reference(),
            "template": MetadataTemplateField().reference(required: false),
        ]
    }

    public init() {}
}

public struct MetadataContentSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "slug": MetadataSlugField().reference(),
            "template": MetadataTemplateField().reference(required: false),
            "publicationDate": MetadataTimestampField()
                .reference(required: false),
            "expirationDate": MetadataTimestampField()
                .reference(required: false),
            "status": MetadataStatusField().reference(),
            "title": MetadataTitleField().reference(),
            "excerpt": MetadataExcerptField().reference(),
            "imageURL": MetadataImageURLField().reference(),
            "canonicalURL": MetadataCanonicalURLField()
                .reference(required: false),
            "noIndex": MetadataNoIndexField().reference(),
            "cssCodeInjection": MetadataCodeInjectionField()
                .reference(required: false),
            "javascriptCodeInjection": MetadataCodeInjectionField()
                .reference(required: false),
            "structuredDataCodeInjection": MetadataCodeInjectionField()
                .reference(required: false),
        ]
    }

    public init() {}
}
