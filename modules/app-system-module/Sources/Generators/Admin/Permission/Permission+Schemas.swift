import FeatherOpenAPI

extension Permission.Schemas {
    struct Key: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemPermissionKeyField" }
        var example: String? = "system.permission:read"
    }

    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemPermissionIDField" }
        var example: String? = "V1StGXR8_Z5jdHi6B-myT"
    }

    struct Name: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemPermissionNameField" }
        var example: String? = "system.permission:read"
    }

    struct Notes: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemPermissionNotesField" }
        var example: String? = "Read system permissions."
    }

    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemPermissionUpdateMask" }
        var example: String? = "key,name,notes"
    }

    struct Search: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemPermissionSearch" }
        var example: String? = "admin"
    }

    struct Limit: IntSchemaRepresentable {
        var openAPIIdentifier: String { "SystemPermissionListLimit" }
        var description: String? {
            "Maximum number of results. Defaults to 20; values are clamped to 1-100."
        }
        var defaultValue: Int? = 20
        var example: Int? = 20
    }

}
