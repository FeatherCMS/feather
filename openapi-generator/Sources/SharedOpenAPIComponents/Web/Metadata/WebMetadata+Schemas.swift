import FeatherOpenAPI
import OpenAPIKit30

public struct WebMetadataSlugField: StringSchemaRepresentable {
    public var example: String? = "homepage"

    public init() {}
}

public struct WebMetadataPathField: StringSchemaRepresentable {
    public var example: String? = "blog"

    public init() {}
}

public struct WebMetadataReferenceTypeField: StringSchemaRepresentable {
    public var example: String? = "web.page"

    public init() {}
}

public struct WebMetadataReferenceIDField: StringSchemaRepresentable {
    public var example: String? = "wp_home"

    public init() {}
}

public struct WebMetadataTimestampField: DoubleSchemaRepresentable {
    public var example: Double? { 1_760_000_000 }

    public init() {}
}

public struct WebMetadataStatusField: StringSchemaRepresentable {
    public var enumValues: [String]? = ["draft", "published", "archived"]
    public var example: String? = "published"

    public init() {}
}

public struct WebMetadataTitleField: StringSchemaRepresentable {
    public var example: String? = "Hello world"

    public init() {}
}

public struct WebMetadataExcerptField: StringSchemaRepresentable {
    public var example: String? = "Short summary"

    public init() {}
}

public struct WebMetadataImageURLField: StringSchemaRepresentable {
    public var example: String? = "/media/assets/example.png"

    public init() {}
}

public struct WebMetadataCanonicalURLField: StringSchemaRepresentable {
    public var example: String? = "https://example.com/posts/hello-world"

    public init() {}
}

public struct WebMetadataNoIndexField: BoolSchemaRepresentable {
    public var example: Bool? = false

    public init() {}
}

public struct WebMetadataCodeInjectionField: StringSchemaRepresentable {
    public var example: String? = "<p>Hello world</p>"

    public init() {}
}

public struct WebMetadataSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "referenceType": WebMetadataReferenceTypeField().reference(),
            "referenceId": WebMetadataReferenceIDField().reference(),
            "slug": WebMetadataSlugField().reference(),
        ]
    }

    public init() {}
}

public struct WebMetadataContentSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "slug": WebMetadataSlugField().reference(),
            "publicationDate": WebMetadataTimestampField()
                .reference(required: false),
            "expirationDate": WebMetadataTimestampField()
                .reference(required: false),
            "status": WebMetadataStatusField().reference(),
            "title": WebMetadataTitleField().reference(),
            "excerpt": WebMetadataExcerptField().reference(),
            "imageURL": WebMetadataImageURLField().reference(),
            "canonicalURL": WebMetadataCanonicalURLField().reference(),
            "noIndex": WebMetadataNoIndexField().reference(),
            "cssCodeInjection": WebMetadataCodeInjectionField().reference(),
            "javascriptCodeInjection": WebMetadataCodeInjectionField()
                .reference(),
            "structuredDataCodeInjection": WebMetadataCodeInjectionField()
                .reference(),
        ]
    }

    public init() {}
}
