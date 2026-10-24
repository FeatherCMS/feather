public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct IdentityIDField: StringSchemaRepresentable {
    public var openAPIIdentifier: String { "UserIdentityIDField" }
    public var example: String? = "usr_a9x1f7Qk2m"

    public init() {}
}

public struct IdentityNameField: StringSchemaRepresentable {
    public var openAPIIdentifier: String { "UserIdentityNameField" }
    public var example: String? = "Root User"

    public init() {}
}

public struct IdentityStatusField: StringSchemaRepresentable {
    public var openAPIIdentifier: String { "UserIdentityStatusField" }
    public var allowedValues: [String]? = [
        "invited",
        "active",
        "suspended",
        "deactivated",
        "anonymized",
    ]
    public var example: String? = "active"

    public init() {}
}

public struct IdentityRoleIDField: StringSchemaRepresentable {
    public var openAPIIdentifier: String { "UserIdentityRoleIDField" }

    public init() {}
}

public struct IdentityRoleIDListSchema: ArraySchemaRepresentable {
    public var openAPIIdentifier: String { "UserIdentityRoleIDListSchema" }

    public init() {}

    public var items: (any SchemaRepresentable)? {
        IdentityRoleIDField()
    }
}

public struct IdentityPermissionIDField: StringSchemaRepresentable {
    public var openAPIIdentifier: String { "UserIdentityPermissionIDField" }

    public init() {}
}

public struct IdentityPermissionIDListSchema: ArraySchemaRepresentable {
    public var openAPIIdentifier: String {
        "UserIdentityPermissionIDListSchema"
    }

    public init() {}

    public var items: (any SchemaRepresentable)? {
        IdentityPermissionIDField()
    }
}

public struct IdentityDetailSchema: ObjectSchemaRepresentable {
    public var openAPIIdentifier: String { "UserIdentityDetailSchema" }

    public var propertyMap: SchemaMap {
        [
            "id": IdentityIDField().reference(),
            "name": IdentityNameField().reference(),
            "status": IdentityStatusField().reference(),
            "roleIds": IdentityRoleIDListSchema()
                .reference(required: false),
        ]
    }

    public init() {}
}
