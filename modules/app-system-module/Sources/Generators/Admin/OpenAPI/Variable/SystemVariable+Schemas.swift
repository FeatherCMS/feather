import FeatherOpenAPI
import OpenAPIKit30

struct SystemVariableKeyField: StringSchemaRepresentable {
    var example: String? = "sys_variable_timezone"
}

struct SystemVariableIDField: StringSchemaRepresentable {
    var example: String? = "V1StGXR8_Z5jdHi6B-myT"
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
            "key": SystemVariableKeyField(),
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
            "id": SystemVariableIDField().reference(),
            "key": SystemVariableKeyField(),
            "value": SystemVariableValueField(),
            "name": SystemVariableNameField().reference(required: false),
            "notes": SystemVariableNotesField().reference(required: false),
        ]
    }
}

struct SystemVariableListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": SystemVariableIDField().reference(),
            "key": SystemVariableKeyField().reference(),
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

struct SystemVariableIDsFilter: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { SystemVariableIDField() }
    var required: Bool { false }
}
