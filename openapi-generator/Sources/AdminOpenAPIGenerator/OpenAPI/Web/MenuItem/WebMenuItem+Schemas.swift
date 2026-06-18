import FeatherOpenAPI
import OpenAPIKit30

struct WebMenuItemIdField: StringSchemaRepresentable {
    var example: String? = "wmi_home"
}

struct WebMenuItemLabelField: StringSchemaRepresentable {
    var example: String? = "Home"
}

struct WebMenuItemURLField: StringSchemaRepresentable {
    var example: String? = "/"
}

struct WebMenuItemPriorityField: IntSchemaRepresentable {
    var example: Int? = 10
}

struct WebMenuItemIsBlankField: BoolSchemaRepresentable {
    var example: Bool? = false
}

struct WebMenuItemPermissionField: StringSchemaRepresentable {
    var example: String? = ""
}

struct WebMenuItemNotesField: StringSchemaRepresentable {
    var example: String? = "Visible for all visitors."
}

struct WebMenuItemCreatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct WebMenuItemUpdatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct WebMenuItemCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "label": WebMenuItemLabelField(),
            "url": WebMenuItemURLField(),
            "priority": WebMenuItemPriorityField(),
            "isBlank": WebMenuItemIsBlankField(),
            "permission": WebMenuItemPermissionField(),
            "notes": WebMenuItemNotesField().reference(required: false),
        ]
    }
}

struct WebMenuItemPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "label": WebMenuItemLabelField().reference(required: false),
            "url": WebMenuItemURLField().reference(required: false),
            "priority": WebMenuItemPriorityField().reference(required: false),
            "isBlank": WebMenuItemIsBlankField().reference(required: false),
            "permission": WebMenuItemPermissionField()
                .reference(required: false),
            "notes": WebMenuItemNotesField().reference(required: false),
        ]
    }
}

struct WebMenuItemDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": WebMenuItemIdField(),
            "menuId": WebMenuIdField(),
            "label": WebMenuItemLabelField(),
            "url": WebMenuItemURLField(),
            "priority": WebMenuItemPriorityField(),
            "isBlank": WebMenuItemIsBlankField(),
            "permission": WebMenuItemPermissionField(),
            "notes": WebMenuItemNotesField(),
            "createdAt": WebMenuItemCreatedAtField(),
            "updatedAt": WebMenuItemUpdatedAtField(),
        ]
    }
}

struct WebMenuItemListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": WebMenuItemIdField().reference(),
            "menuId": WebMenuIdField().reference(),
            "label": WebMenuItemLabelField().reference(),
            "url": WebMenuItemURLField().reference(),
            "priority": WebMenuItemPriorityField().reference(),
            "isBlank": WebMenuItemIsBlankField().reference(),
            "permission": WebMenuItemPermissionField().reference(),
            "createdAt": WebMenuItemCreatedAtField().reference(),
            "updatedAt": WebMenuItemUpdatedAtField().reference(),
        ]
    }
}

struct WebMenuItemListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { WebMenuItemListItemSchema().reference() }
}
