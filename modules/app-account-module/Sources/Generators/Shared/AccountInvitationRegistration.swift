import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserSharedOpenAPIGenerator

public struct AccountInvitationValidationSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "email": AccountInvitationRegistrationEmailField().reference(),
            "expiresAt": AccountInvitationRegistrationExpiresAtField().reference(),
        ]
    }

    public init() {}
}

struct AccountInvitationRegistrationEmailField: StringSchemaRepresentable {
    var example: String? { "user@example.com" }
}

struct AccountInvitationRegistrationExpiresAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct AccountInvitationValidationResponse: JSONResponseRepresentable {
    var description: String = "Invitation validation response"
    var schema = AccountInvitationValidationSchema().reference()
}

public struct AccountInvitationExchangeRequestSchema:
    ObjectSchemaRepresentable
{
    public var propertyMap: SchemaMap {
        [
            "token": AccountAuthMagicLinkTokenField().reference(),
            "password": AccountRegisterPasswordField().reference(),
        ]
    }

    public init() {}
}

public struct AccountInvitationExchangeRequestBody:
    RequestBodyRepresentable
{
    public var description: String? {
        "Account invitation registration request"
    }
    public var contentMap: ContentMap {
        [
            .json: Content(
                AccountInvitationExchangeRequestSchema().reference()
            )
        ]
    }

    public init() {}
}

public struct AccountInvitationExchangeOperation: OperationRepresentable {
    public var tags: [TagRepresentable] { [AccountTag()] }
    public var requestBody: RequestBodyRepresentable? {
        AccountInvitationExchangeRequestBody().reference()
    }
    public var responseMap: ResponseMap {
        [200: AccountAuthResponse().reference()]
    }

    public init() {}
}

public struct AccountInvitationExchangePathItems: PathItemRepresentable {
    public var get: OperationRepresentable? {
        AccountInvitationValidationOperation()
    }

    public var post: OperationRepresentable? {
        AccountInvitationExchangeOperation()
    }

    public init() {}
}

struct AccountInvitationValidationOperation: OperationRepresentable {
    public var tags: [TagRepresentable] { [AccountTag()] }
    public var parameters: [ParameterRepresentable] {
        [AccountInvitationTokenParameter().reference()]
    }
    public var responseMap: ResponseMap {
        [200: AccountInvitationValidationResponse().reference()]
    }
}

struct AccountInvitationTokenParameter: QueryParameterRepresentable {
    var name: String { "token" }
    var description: String? { "Invitation token" }
    var schema: any OpenAPISchemaRepresentable {
        AccountAuthMagicLinkTokenField().reference()
    }
}
