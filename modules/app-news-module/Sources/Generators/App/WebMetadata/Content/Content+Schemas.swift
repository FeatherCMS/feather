public import FeatherOpenAPI

extension WebMetadata.Content {
    public enum Schemas {}
}

extension WebMetadata.Content.Schemas {
    public struct Slug: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataSlugField" }
        public var example: String? = "homepage"

        public init() {}
    }

    public struct Template: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataTemplateField" }
        public var example: String? = "default"

        public init() {}
    }

    public struct Status: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataStatusField" }
        public var enumValues: [String]? = ["draft", "published", "archived"]
        public var example: String? = "published"

        public init() {}
    }

    public struct Timestamp: DoubleSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataTimestampField" }
        public var example: Double? { 1_760_000_000 }

        public init() {}
    }

    public struct Title: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataTitleField" }
        public var example: String? = "Hello world"

        public init() {}
    }

    public struct Excerpt: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataExcerptField" }
        public var example: String? = "Short summary"

        public init() {}
    }

    public struct ImageURL: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataImageURLField" }
        public var example: String? =
            "/public/12/34/56789/originals/example.png"

        public init() {}
    }

    public struct CanonicalURL: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataCanonicalURLField" }
        public var example: String? = "https://example.com/posts/hello-world"

        public init() {}
    }

    public struct NoIndex: BoolSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataNoIndexField" }
        public var example: Bool? = false

        public init() {}
    }

    public struct CodeInjection: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataCodeInjectionField" }
        public var example: String? = "<p>Hello world</p>"

        public init() {}
    }
}

extension WebMetadata.Content {
    public struct Schema: ObjectSchemaRepresentable {
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
