public import FeatherOpenAPI
import OpenAPIKit30

public extension WebMetadata.Content {
    enum Schemas {}
}

public extension WebMetadata.Content.Schemas {
    struct Slug: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataSlugField" }
        public var example: String? = "homepage"

        public init() {}
    }

    struct Template: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataTemplateField" }
        public var example: String? = "default"

        public init() {}
    }

    struct Status: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataStatusField" }
        public var enumValues: [String]? = ["draft", "published", "archived"]
        public var example: String? = "published"

        public init() {}
    }

    struct Timestamp: DoubleSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataTimestampField" }
        public var example: Double? { 1_760_000_000 }

        public init() {}
    }

    struct Title: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataTitleField" }
        public var example: String? = "Hello world"

        public init() {}
    }

    struct Excerpt: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataExcerptField" }
        public var example: String? = "Short summary"

        public init() {}
    }

    struct ImageURL: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataImageURLField" }
        public var example: String? = "/public/12/34/56789/originals/example.png"

        public init() {}
    }

    struct CanonicalURL: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataCanonicalURLField" }
        public var example: String? = "https://example.com/posts/hello-world"

        public init() {}
    }

    struct NoIndex: BoolSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataNoIndexField" }
        public var example: Bool? = false

        public init() {}
    }

    struct CodeInjection: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataCodeInjectionField" }
        public var example: String? = "<p>Hello world</p>"

        public init() {}
    }
}

public extension WebMetadata.Content {
    struct Schema: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataContentSchema" }
        public var propertyMap: SchemaMap {
            [
                "slug": Schemas.Slug().reference(),
                "template": Schemas.Template().reference(required: false),
                "publicationDate": Schemas.Timestamp()
                    .reference(required: false),
                "expirationDate": Schemas.Timestamp()
                    .reference(required: false),
                "status": Schemas.Status().reference(),
                "title": Schemas.Title().reference(),
                "excerpt": Schemas.Excerpt().reference(),
                "imageURL": Schemas.ImageURL().reference(),
                "canonicalURL": Schemas.CanonicalURL()
                    .reference(required: false),
                "noIndex": Schemas.NoIndex().reference(),
                "cssCodeInjection": Schemas.CodeInjection()
                    .reference(required: false),
                "javascriptCodeInjection": Schemas.CodeInjection()
                    .reference(required: false),
                "structuredDataCodeInjection": Schemas.CodeInjection()
                    .reference(required: false),
            ]
        }

        public init() {}
    }
}
