public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public struct PageIdField: StringSchemaRepresentable {
    public var example: String? = "wp_home"

    public init() {}
}

public struct PageContentField: StringSchemaRepresentable {
    public var example: String? = "<h1>Homepage</h1>"

    public init() {}
}

public struct PageTitleField: StringSchemaRepresentable {
    public var example: String? = "Homepage"

    public init() {}
}

public struct PageExcerptField: StringSchemaRepresentable {
    public var example: String? = "Short page summary."

    public init() {}
}

public struct PageImageURLField: StringSchemaRepresentable {
    public var example: String? = "/public/12/34/56789/originals/homepage.png"

    public init() {}
}

public struct PageDetailSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "id": PageIdField().reference(),
            "title": PageTitleField().reference(),
            "excerpt": PageExcerptField().reference(),
            "content": PageContentField().reference(),
            "imageURL": PageImageURLField().reference(),
            "media": MediaAssetSchema().reference(required: false),
            "metadata": MetadataContentSchema().reference(),
        ]
    }

    public init() {}
}
