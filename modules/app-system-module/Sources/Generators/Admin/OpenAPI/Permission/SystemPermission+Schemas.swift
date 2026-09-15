import FeatherOpenAPI
import OpenAPIKit30

struct SystemPermissionKeyField: StringSchemaRepresentable {
    var example: String? = "system.permission:read"
}

struct SystemPermissionIDField: StringSchemaRepresentable {
    var example: String? = "V1StGXR8_Z5jdHi6B-myT"
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
            "key": SystemPermissionKeyField(),
            "name": SystemPermissionNameField().reference(required: false),
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
            "id": SystemPermissionIDField().reference(),
            "key": SystemPermissionKeyField(),
            "name": SystemPermissionNameField().reference(required: false),
            "notes": SystemPermissionNotesField().reference(required: false),
        ]
    }
}

struct SystemPermissionListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": SystemPermissionIDField().reference(),
            "key": SystemPermissionKeyField().reference(),
            "name": SystemPermissionNameField().reference(required: false),
            "notes": SystemPermissionNotesField().reference(required: false),
        ]
    }
}

struct SystemPermissionListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        SystemPermissionListItemSchema().reference()
    }
}

struct SystemPermissionIDsFilter: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { SystemPermissionIDField() }
    var required: Bool { false }
}
