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
            "name": SystemVariableNameField(),
            "value": SystemVariableValueField(),
            "notes": SystemVariableNotesField().reference(required: false),
        ]
    }
}

struct SystemVariablePatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "name": SystemVariableNameField().reference(required: false),
            "value": SystemVariableValueField().reference(required: false),
            "notes": SystemVariableNotesField().reference(required: false),
        ]
    }
}

struct SystemVariableDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": SystemVariableIdField(),
            "name": SystemVariableNameField(),
            "value": SystemVariableValueField(),
            "notes": SystemVariableNotesField(),
        ]
    }
}

struct SystemVariableListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": SystemVariableIdField().reference(),
            "name": SystemVariableNameField().reference(),
            "value": SystemVariableValueField().reference(),
        ]
    }
}

struct SystemVariableListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        SystemVariableListItemSchema().reference()
    }
}
