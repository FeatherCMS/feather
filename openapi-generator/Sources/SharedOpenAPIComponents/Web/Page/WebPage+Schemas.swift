import FeatherOpenAPI
import OpenAPIKit30

public struct WebPageIdField: StringSchemaRepresentable {
    public var example: String? = "wp_home"

    public init() {}
}

public struct WebPageContentField: StringSchemaRepresentable {
    public var example: String? = "<h1>Homepage</h1>"

    public init() {}
}

public struct WebPageExcerptField: StringSchemaRepresentable {
    public var example: String? = "Short page summary."

    public init() {}
}

public struct WebPageImageURLField: StringSchemaRepresentable {
    public var example: String? = "/media/assets/homepage.png"

    public init() {}
}

public struct WebPageDetailSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "id": WebPageIdField().reference(),
            "excerpt": WebPageExcerptField().reference(),
            "content": WebPageContentField().reference(),
            "imageURL": WebPageImageURLField().reference(),
            "media": MediaAssetSchema().reference(required: false),
            "metadata": WebMetadataContentSchema().reference(),
        ]
    }

    public init() {}
}
