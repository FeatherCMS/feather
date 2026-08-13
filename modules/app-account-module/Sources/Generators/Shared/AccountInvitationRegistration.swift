import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserSharedOpenAPIGenerator

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
    public var post: OperationRepresentable? {
        AccountInvitationExchangeOperation()
    }

    public init() {}
}
