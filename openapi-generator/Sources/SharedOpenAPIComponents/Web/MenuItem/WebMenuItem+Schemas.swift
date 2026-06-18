import FeatherOpenAPI
import OpenAPIKit30

public struct WebMenuItemIdField: StringSchemaRepresentable {
    public var example: String? = "wmi_home"

    public init() {}
}

public struct WebMenuItemLabelField: StringSchemaRepresentable {
    public var example: String? = "Home"

    public init() {}
}

public struct WebMenuItemURLField: StringSchemaRepresentable {
    public var example: String? = "/"

    public init() {}
}

public struct WebMenuItemPriorityField: IntSchemaRepresentable {
    public var example: Int? = 10

    public init() {}
}

public struct WebMenuItemIsBlankField: BoolSchemaRepresentable {
    public var example: Bool? = false

    public init() {}
}

public struct WebMenuItemListSchema: ArraySchemaRepresentable {
    public var items: SchemaRepresentable? { WebMenuItemSchema().reference() }

    public init() {}
}

public struct WebMenuItemSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "id": WebMenuItemIdField().reference(),
            "label": WebMenuItemLabelField().reference(),
            "url": WebMenuItemURLField().reference(),
            "priority": WebMenuItemPriorityField().reference(),
            "isBlank": WebMenuItemIsBlankField().reference(),
        ]
    }

    public init() {}
}
