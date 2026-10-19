import FeatherOpenAPI

extension Variable.Schemas {
    struct Key: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemVariableKeyField" }
        var example: String? = "sys_variable_timezone"
    }

    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemVariableIDField" }
        var example: String? = "V1StGXR8_Z5jdHi6B-myT"
    }

    struct Name: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemVariableNameField" }
        var example: String? = "default_timezone"
    }

    struct Value: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemVariableValueField" }
        var example: String? = "UTC"
    }

    struct Notes: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemVariableNotesField" }
        var example: String? = "Application default timezone."
    }

    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemVariableUpdateMask" }
        var example: String? = "key,value,name,notes"
    }

    struct Search: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemVariableSearch" }
        var example: String? = "mail"
    }

    struct Limit: IntSchemaRepresentable {
        var openAPIIdentifier: String { "SystemVariableListLimit" }
        var description: String? {
            "Maximum number of results. Defaults to 20; values are clamped to 1-100."
        }
        var defaultValue: Int? = 20
        var example: Int? = 20
    }

}
