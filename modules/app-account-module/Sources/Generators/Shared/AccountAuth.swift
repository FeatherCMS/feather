import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserSharedOpenAPIGenerator

public struct AccountAuthTokenField: StringSchemaRepresentable {
    public var example: String? = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    public init() {}
}

public struct AccountAuthMagicLinkTokenField: StringSchemaRepresentable {
    public var example: String? = "mgl_3XbY..."
    public init() {}
}

public struct AccountSettingsLanguageField: StringSchemaRepresentable {
    public var example: String? = "en"

    public init() {}
}

public struct AccountSettingsTimezoneField: StringSchemaRepresentable {
    public var example: String? = "UTC"

    public init() {}
}

public struct AccountSettingsPageSizeField: IntSchemaRepresentable {
    public var example: Int? = 20

    public init() {}
}

public struct AccountProfileNameField: SchemaRepresentable {
    public var required: Bool

    public init(required: Bool = true) {
        self.required = required
    }

    public func openAPISchema() -> JSONSchema {
        .string(required: required, nullable: true)
    }
}

public struct AccountProfileImageAssetIDField: SchemaRepresentable {
    public var required: Bool

    public init(required: Bool = true) {
        self.required = required
    }

    public func openAPISchema() -> JSONSchema {
        .string(required: required, nullable: true)
    }
}

public struct AccountProfileResponseSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "firstName": AccountProfileNameField(required: false),
            "lastName": AccountProfileNameField(required: false),
            "profileImageAssetId": AccountProfileImageAssetIDField(required: false),
        ]
    }

    public init() {}
}

public struct AccountProfileResponse: JSONResponseRepresentable {
    public var description: String = "Account profile response"
    public var schema = AccountProfileResponseSchema().reference()

    public init() {}
}

public struct AccountProfileUpdateSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "firstName": AccountProfileNameField(required: false),
            "lastName": AccountProfileNameField(required: false),
            "profileImageAssetId": AccountProfileImageAssetIDField(required: false),
        ]
    }

    public init() {}
}

public struct AccountProfileUpdateRequestBody: RequestBodyRepresentable {
    public var contentMap: ContentMap {
        [.json: Content(AccountProfileUpdateSchema().reference())]
    }

    public init() {}
}

public struct AccountAuthResponseSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "user": UserIdentityDetailSchema().reference(),
            "roles": UserIdentityRoleIDListSchema(),
            "permissions": UserIdentityPermissionIDListSchema(),
            "token": AccountAuthTokenField().reference(),
        ]
    }

    public init() {}
}

public struct AccountAuthResponse: JSONResponseRepresentable {
    public var description: String = "Account authentication response"
    public var schema = AccountAuthResponseSchema().reference()
    public init() {}
}

public struct AccountSettingsResponseSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "language": AccountSettingsLanguageField().reference(),
            "timezone": AccountSettingsTimezoneField().reference(),
            "pageSize": AccountSettingsPageSizeField().reference(),
        ]
    }

    public init() {}
}

public struct AccountSettingsResponse: JSONResponseRepresentable {
    public var description: String = "Account settings response"
    public var schema = AccountSettingsResponseSchema().reference()

    public init() {}
}

public struct AccountTag: TagRepresentable {
    public var name: String = "Account"
    public var description: String? = "Account endpoints."
    public init() {}
}
