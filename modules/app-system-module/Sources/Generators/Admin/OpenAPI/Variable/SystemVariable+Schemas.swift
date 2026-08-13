import FeatherOpenAPI
import OpenAPIKit30

struct SystemVariableIdField: StringSchemaRepresentable {
    var example: String? = "sys_variable_timezone"
}

struct SystemVariableNameField: StringSchemaRepresentable {
    var example: String? = "default_timezone"
}

struct SystemVariableValueField: StringSchemaRepresentable {
    var example: String? = "UTC"
}

struct SystemVariableNotesField: StringSchemaRepresentable {
    var example: String? = "Application default timezone."
}

struct SystemVariableCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": SystemVariableIdField(),
            "value": SystemVariableValueField(),
            "name": SystemVariableNameField().reference(required: false),
            "notes": SystemVariableNotesField().reference(required: false),
        ]
    }
}

struct SystemVariablePatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "value": SystemVariableValueField().reference(required: false),
            "name": SystemVariableNameField().reference(required: false),
            "notes": SystemVariableNotesField().reference(required: false),
        ]
    }
}

struct SystemVariableDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": SystemVariableIdField(),
            "value": SystemVariableValueField(),
            "name": SystemVariableNameField().reference(required: false),
            "notes": SystemVariableNotesField().reference(required: false),
        ]
    }
}

struct SystemVariableListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": SystemVariableIdField().reference(),
            "value": SystemVariableValueField().reference(),
            "name": SystemVariableNameField().reference(required: false),
            "notes": SystemVariableNotesField().reference(required: false),
        ]
    }
}

struct SystemVariableListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        SystemVariableListItemSchema().reference()
    }
}
