import FeatherOpenAPI
import OpenAPIKit30

struct BlogAuthorLinkIdField: StringSchemaRepresentable {
    var example: String? = "wmi_home"
}

struct BlogAuthorLinkLabelField: StringSchemaRepresentable {
    var example: String? = "Home"
}

struct BlogAuthorLinkURLField: StringSchemaRepresentable {
    var example: String? = "/"
}

struct BlogAuthorLinkPriorityField: IntSchemaRepresentable {
    var example: Int? = 10
}

struct BlogAuthorLinkIsBlankField: BoolSchemaRepresentable {
    var example: Bool? = false
}

struct BlogAuthorLinkPermissionField: StringSchemaRepresentable {
    var example: String? = ""
}

struct BlogAuthorLinkNotesField: StringSchemaRepresentable {
    var example: String? = "Visible for all visitors."
}

struct BlogAuthorLinkCreatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct BlogAuthorLinkUpdatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct BlogAuthorLinkCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "label": BlogAuthorLinkLabelField(),
            "url": BlogAuthorLinkURLField(),
            "priority": BlogAuthorLinkPriorityField(),
            "isBlank": BlogAuthorLinkIsBlankField(),
            "permission": BlogAuthorLinkPermissionField(),
            "notes": BlogAuthorLinkNotesField().reference(required: false),
        ]
    }
}

struct BlogAuthorLinkPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "label": BlogAuthorLinkLabelField().reference(required: false),
            "url": BlogAuthorLinkURLField().reference(required: false),
            "priority": BlogAuthorLinkPriorityField()
                .reference(required: false),
            "isBlank": BlogAuthorLinkIsBlankField().reference(required: false),
            "permission": BlogAuthorLinkPermissionField()
                .reference(required: false),
            "notes": BlogAuthorLinkNotesField().reference(required: false),
        ]
    }
}

struct BlogAuthorLinkDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": BlogAuthorLinkIdField(),
            "menuId": BlogAuthorIdField(),
            "label": BlogAuthorLinkLabelField(),
            "url": BlogAuthorLinkURLField(),
            "priority": BlogAuthorLinkPriorityField(),
            "isBlank": BlogAuthorLinkIsBlankField(),
            "permission": BlogAuthorLinkPermissionField(),
            "notes": BlogAuthorLinkNotesField(),
            "createdAt": BlogAuthorLinkCreatedAtField(),
            "updatedAt": BlogAuthorLinkUpdatedAtField(),
        ]
    }
}

struct BlogAuthorLinkListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": BlogAuthorLinkIdField().reference(),
            "menuId": BlogAuthorIdField().reference(),
            "label": BlogAuthorLinkLabelField().reference(),
            "url": BlogAuthorLinkURLField().reference(),
            "priority": BlogAuthorLinkPriorityField().reference(),
            "isBlank": BlogAuthorLinkIsBlankField().reference(),
            "permission": BlogAuthorLinkPermissionField().reference(),
            "createdAt": BlogAuthorLinkCreatedAtField().reference(),
            "updatedAt": BlogAuthorLinkUpdatedAtField().reference(),
        ]
    }
}

struct BlogAuthorLinkListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        BlogAuthorLinkListItemSchema().reference()
    }
}
