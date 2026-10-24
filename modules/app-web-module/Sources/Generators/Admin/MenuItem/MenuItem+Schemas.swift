public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct MenuItemIdField: StringSchemaRepresentable {
    var example: String? = "wmi_home"
}

struct MenuItemLabelField: StringSchemaRepresentable {
    var example: String? = "Home"
}

struct MenuItemURLField: StringSchemaRepresentable {
    var example: String? = "/"
}

struct MenuItemPriorityField: IntSchemaRepresentable {
    var example: Int? = 10
}

struct MenuItemIsBlankField: BoolSchemaRepresentable {
    var example: Bool? = false
}

struct MenuItemPermissionField: StringSchemaRepresentable {
    var example: String? = ""
}

struct MenuItemAuthenticationField: StringSchemaRepresentable {
    var example: String? = "any"
}

struct MenuItemNotesField: StringSchemaRepresentable {
    var example: String? = "Visible for all visitors."
}

struct MenuItemCreatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct MenuItemUpdatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct MenuItemCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "label": MenuItemLabelField(),
            "url": MenuItemURLField(),
            "priority": MenuItemPriorityField(),
            "isBlank": MenuItemIsBlankField(),
            "permission": MenuItemPermissionField(),
            "authentication": MenuItemAuthenticationField()
                .reference(required: false),
            "notes": MenuItemNotesField().reference(required: false),
        ]
    }
}

struct MenuItemPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "label": MenuItemLabelField().reference(required: false),
            "url": MenuItemURLField().reference(required: false),
            "priority": MenuItemPriorityField().reference(required: false),
            "isBlank": MenuItemIsBlankField().reference(required: false),
            "permission": MenuItemPermissionField()
                .reference(required: false),
            "authentication": MenuItemAuthenticationField()
                .reference(required: false),
            "notes": MenuItemNotesField().nullable().reference(required: false),
        ]
    }
}

struct MenuItemDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": MenuItemIdField(),
            "menuId": MenuIdField(),
            "label": MenuItemLabelField(),
            "url": MenuItemURLField(),
            "priority": MenuItemPriorityField(),
            "isBlank": MenuItemIsBlankField(),
            "permission": MenuItemPermissionField(),
            "authentication": MenuItemAuthenticationField(),
            "notes": MenuItemNotesField().reference(required: false),
            "createdAt": MenuItemCreatedAtField(),
            "updatedAt": MenuItemUpdatedAtField(),
        ]
    }
}

struct MenuItemListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": MenuItemIdField().reference(),
            "menuId": MenuIdField().reference(),
            "label": MenuItemLabelField().reference(),
            "url": MenuItemURLField().reference(),
            "priority": MenuItemPriorityField().reference(),
            "isBlank": MenuItemIsBlankField().reference(),
            "permission": MenuItemPermissionField().reference(),
            "authentication": MenuItemAuthenticationField().reference(),
            "createdAt": MenuItemCreatedAtField().reference(),
            "updatedAt": MenuItemUpdatedAtField().reference(),
        ]
    }
}

struct MenuItemListSchema: ArraySchemaRepresentable {
    var items: (any SchemaRepresentable)? {
        MenuItemListItemSchema().reference()
    }
}
