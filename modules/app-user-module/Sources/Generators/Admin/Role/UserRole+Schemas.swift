import FeatherOpenAPI
import OpenAPIKit30

struct UserRoleIdField: StringSchemaRepresentable {
    var example: String? = "role_manager"
}

struct UserRoleNameField: StringSchemaRepresentable {
    var example: String? = "manager"
}

struct UserRoleNotesField: StringSchemaRepresentable {
    var example: String? = "Management role."
}

struct UserRoleCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": UserRoleIdField(),
            "name": UserRoleNameField().reference(required: false),
            "notes": UserRoleNotesField().reference(required: false),
        ]
    }
}

struct UserRolePatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "name": UserRoleNameField().reference(required: false),
            "notes": UserRoleNotesField().reference(required: false),
        ]
    }
}

struct UserRoleDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": UserRoleIdField(),
            "name": UserRoleNameField().reference(required: false),
            "notes": UserRoleNotesField().reference(required: false),
        ]
    }
}

struct UserRoleListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": UserRoleIdField().reference(),
            "name": UserRoleNameField().reference(required: false),
        ]
    }
}

struct UserRoleListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { UserRoleListItemSchema().reference() }
}
