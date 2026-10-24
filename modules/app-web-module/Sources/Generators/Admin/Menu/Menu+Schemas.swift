public import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct MenuIdField: StringSchemaRepresentable {
    var example: String? = "wm_header"
}

struct MenuKeyField: StringSchemaRepresentable {
    var example: String? = "header"
}

struct MenuNameField: StringSchemaRepresentable {
    var example: String? = "Header menu"
}

struct MenuNotesField: StringSchemaRepresentable {
    var example: String? = "Primary site navigation."
}

struct MenuCreatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct MenuUpdatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct MenuCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "key": MenuKeyField(),
            "name": MenuNameField(),
            "notes": MenuNotesField().reference(required: false),
        ]
    }
}

struct MenuPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "key": MenuKeyField().reference(required: false),
            "name": MenuNameField().reference(required: false),
            "notes": MenuNotesField().nullable().reference(required: false),
        ]
    }
}

struct MenuDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": MenuIdField(),
            "key": MenuKeyField(),
            "name": MenuNameField(),
            "notes": MenuNotesField().reference(required: false),
            "createdAt": MenuCreatedAtField(),
            "updatedAt": MenuUpdatedAtField(),
        ]
    }
}

struct MenuListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": MenuIdField().reference(),
            "key": MenuKeyField().reference(),
            "name": MenuNameField().reference(),
            "createdAt": MenuCreatedAtField().reference(),
            "updatedAt": MenuUpdatedAtField().reference(),
        ]
    }
}

struct MenuListSchema: ArraySchemaRepresentable {
    var items: (any SchemaRepresentable)? {
        MenuListItemSchema().reference()
    }
}
