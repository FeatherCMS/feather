public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public struct MenuItemIdField: StringSchemaRepresentable {
    public var example: String? = "wmi_home"

    public init() {}
}

public struct MenuItemLabelField: StringSchemaRepresentable {
    public var example: String? = "Home"

    public init() {}
}

public struct MenuItemURLField: StringSchemaRepresentable {
    public var example: String? = "/"

    public init() {}
}

public struct MenuItemPriorityField: IntSchemaRepresentable {
    public var example: Int? = 10

    public init() {}
}

public struct MenuItemIsBlankField: BoolSchemaRepresentable {
    public var example: Bool? = false

    public init() {}
}

public struct MenuItemListSchema: ArraySchemaRepresentable {
    public var items: (any SchemaRepresentable)? {
        MenuItemSchema().reference()
    }

    public init() {}
}

public struct MenuItemSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "id": MenuItemIdField().reference(),
            "label": MenuItemLabelField().reference(),
            "url": MenuItemURLField().reference(),
            "priority": MenuItemPriorityField().reference(),
            "isBlank": MenuItemIsBlankField().reference(),
        ]
    }

    public init() {}
}
