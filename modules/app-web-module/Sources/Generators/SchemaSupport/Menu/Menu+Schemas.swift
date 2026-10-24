public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct MenuIdField: StringSchemaRepresentable {
    public var example: String? = "wm_header"

    public init() {}
}

public struct MenuKeyField: StringSchemaRepresentable {
    public var example: String? = "header"

    public init() {}
}

public struct MenuNameField: StringSchemaRepresentable {
    public var example: String? = "Header menu"

    public init() {}
}

public struct MenuListSchema: ArraySchemaRepresentable {
    public var items: (any SchemaRepresentable)? { MenuSchema().reference() }

    public init() {}
}

public struct MenuSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "id": MenuIdField().reference(),
            "key": MenuKeyField().reference(),
            "name": MenuNameField().reference(),
            "items": MenuItemListSchema().reference(),
        ]
    }

    public init() {}
}
