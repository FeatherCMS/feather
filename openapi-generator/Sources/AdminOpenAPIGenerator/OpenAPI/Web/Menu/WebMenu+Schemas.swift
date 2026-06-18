import FeatherOpenAPI
import OpenAPIKit30

struct WebMenuIdField: StringSchemaRepresentable {
    var example: String? = "wm_header"
}

struct WebMenuKeyField: StringSchemaRepresentable {
    var example: String? = "header"
}

struct WebMenuNameField: StringSchemaRepresentable {
    var example: String? = "Header menu"
}

struct WebMenuNotesField: StringSchemaRepresentable {
    var example: String? = "Primary site navigation."
}

struct WebMenuCreatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct WebMenuUpdatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct WebMenuCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "key": WebMenuKeyField(),
            "name": WebMenuNameField(),
            "notes": WebMenuNotesField().reference(required: false),
        ]
    }
}

struct WebMenuPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "key": WebMenuKeyField().reference(required: false),
            "name": WebMenuNameField().reference(required: false),
            "notes": WebMenuNotesField().reference(required: false),
        ]
    }
}

struct WebMenuDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": WebMenuIdField(),
            "key": WebMenuKeyField(),
            "name": WebMenuNameField(),
            "notes": WebMenuNotesField(),
            "createdAt": WebMenuCreatedAtField(),
            "updatedAt": WebMenuUpdatedAtField(),
        ]
    }
}

struct WebMenuListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": WebMenuIdField().reference(),
            "key": WebMenuKeyField().reference(),
            "name": WebMenuNameField().reference(),
            "createdAt": WebMenuCreatedAtField().reference(),
            "updatedAt": WebMenuUpdatedAtField().reference(),
        ]
    }
}

struct WebMenuListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { WebMenuListItemSchema().reference() }
}
