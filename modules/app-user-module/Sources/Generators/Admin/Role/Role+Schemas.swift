import FeatherOpenAPI

extension Role.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "UserRoleIdField" }
        var example: String? = "role_manager"
    }

    struct Key: StringSchemaRepresentable {
        var openAPIIdentifier: String { "UserRoleKeyField" }
        var example: String? = "editor"
    }

    struct Name: StringSchemaRepresentable {
        var openAPIIdentifier: String { "UserRoleNameField" }
        var example: String? = "manager"
    }

    struct Notes: StringSchemaRepresentable {
        var openAPIIdentifier: String { "UserRoleNotesField" }
        var example: String? = "Management role."
    }

    struct Search: StringSchemaRepresentable {
        var openAPIIdentifier: String { "UserRoleSearch" }
        var example: String? = "editor"
    }

    struct ListLimit: IntSchemaRepresentable {
        var openAPIIdentifier: String { "UserRoleListLimit" }
        var description: String? {
            "Maximum number of roles. Defaults to 20; values are clamped to 1-100."
        }
        var defaultValue: Int? = 20
        var example: Int? = 100
    }
}
