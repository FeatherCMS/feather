import FeatherOpenAPI
import OpenAPIKit30

struct SystemPermissionIdField: StringSchemaRepresentable {
    var example: String? = "system.permission:read"
}

struct SystemPermissionNameField: StringSchemaRepresentable {
    var example: String? = "system.permission:read"
}

struct SystemPermissionNotesField: StringSchemaRepresentable {
    var example: String? = "Read system permissions."
}

struct SystemPermissionCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "name": SystemPermissionNameField(),
            "notes": SystemPermissionNotesField().reference(required: false),
        ]
    }
}

struct SystemPermissionPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "name": SystemPermissionNameField().reference(required: false),
            "notes": SystemPermissionNotesField().reference(required: false),
        ]
    }
}

struct SystemPermissionDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": SystemPermissionIdField(),
            "name": SystemPermissionNameField(),
            "notes": SystemPermissionNotesField(),
        ]
    }
}

struct SystemPermissionListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": SystemPermissionIdField().reference(),
            "name": SystemPermissionNameField().reference(),
        ]
    }
}

struct SystemPermissionListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        SystemPermissionListItemSchema().reference()
    }
}
