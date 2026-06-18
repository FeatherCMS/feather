import FeatherOpenAPI
import OpenAPIKit30

public struct WebMenuIdField: StringSchemaRepresentable {
    public var example: String? = "wm_header"

    public init() {}
}

public struct WebMenuKeyField: StringSchemaRepresentable {
    public var example: String? = "header"

    public init() {}
}

public struct WebMenuNameField: StringSchemaRepresentable {
    public var example: String? = "Header menu"

    public init() {}
}

public struct WebMenuListSchema: ArraySchemaRepresentable {
    public var items: SchemaRepresentable? { WebMenuSchema().reference() }

    public init() {}
}

public struct WebMenuSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "id": WebMenuIdField().reference(),
            "key": WebMenuKeyField().reference(),
            "name": WebMenuNameField().reference(),
            "items": WebMenuItemListSchema().reference(),
        ]
    }

    public init() {}
}
