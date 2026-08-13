import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public struct AccountRegisterEmailField: StringSchemaRepresentable {
    public var example: String? = "admin@example.com"

    public init() {}
}

public struct AccountRegisterPasswordField: StringSchemaRepresentable {
    public var example: String? = "password"

    public init() {}
}

public struct AccountRegisterSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "email": AccountRegisterEmailField().reference(),
            "password": AccountRegisterPasswordField().reference(),
        ]
    }

    public init() {}
}

public struct AccountRegisterRequestBody: RequestBodyRepresentable {
    public var contentMap: ContentMap {
        [
            .json: Content(AccountRegisterSchema().reference())
        ]
    }

    public init() {}
}

public struct AccountRegisterOperation: OperationRepresentable {
    public var tags: [TagRepresentable] { [AccountTag()] }

    public var requestBody: RequestBodyRepresentable? {
        AccountRegisterRequestBody().reference()
    }

    public var responseMap: ResponseMap {
        [
            201: AccountAuthResponse().reference()
        ]
    }

    public init() {}
}

public struct AccountRegisterPathItems: PathItemRepresentable {
    public var post: OperationRepresentable? {
        AccountRegisterOperation()
    }

    public init() {}
}

public struct AccountSettingsOperation: OperationRepresentable,
    BearerProtectedOperation
{
    public var tags: [TagRepresentable] { [AccountTag()] }

    public var responseMap: ResponseMap {
        [200: AccountSettingsResponse().reference()]
    }

    public init() {}
}

public struct AccountSettingsPathItems: PathItemRepresentable {
    public var get: OperationRepresentable? {
        AccountSettingsOperation()
    }

    public init() {}
}
