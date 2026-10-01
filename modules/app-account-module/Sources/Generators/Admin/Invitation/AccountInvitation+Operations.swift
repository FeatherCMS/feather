import AccountSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol AccountInvitationOperation: BearerProtectedOperation {
}

extension AccountInvitationOperation {
    public var tags: [any TagRepresentable] { [AccountInvitationTag()] }
}

public protocol AccountInvitationIDOperation: AccountInvitationOperation {
}

extension AccountInvitationIDOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            AccountInvitationIdParameter().reference()
        ]
    }
}

struct AccountInvitationCreateOperation: AccountInvitationOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        AccountInvitationRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            201: AccountInvitationDetailResponse().reference()
        ]
    }
}

struct AccountInvitationListOperation: AccountInvitationOperation {
    var responseMap: ResponseMap {
        [
            200: AccountInvitationListResponse().reference()
        ]
    }
}

struct AccountInvitationSearchOperation: AccountInvitationOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: AccountInvitationListItemSchema(),
            sortFieldKeys: [
                "id",
                "email",
                "token",
                "expiresAt",
            ],
            filters: SearchFilterSchema()
        )
    }

    var requestBody: (any RequestBodyRepresentable)? {
        SearchRequestBody(query: searchQuery)
    }

    var responseMap: ResponseMap {
        [
            200: SearchResponse(query: searchQuery).reference()
        ]
    }
}

struct AccountInvitationRemoveOperation: AccountInvitationOperation,
    DeleteOperation
{
}

struct AccountInvitationGetOperation: AccountInvitationIDOperation {
    var responseMap: ResponseMap {
        [
            200: AccountInvitationDetailResponse().reference(),
            404: CustomResponse(description: "AccountInvitation not found"),
        ]
    }
}

struct AccountInvitationUpdateOperation: AccountInvitationIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        AccountInvitationUpdateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: AccountInvitationDetailResponse().reference(),
            404: CustomResponse(description: "AccountInvitation not found"),
        ]
    }
}

struct AccountInvitationPatchOperation: AccountInvitationIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        AccountInvitationPatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: AccountInvitationDetailResponse().reference(),
            404: CustomResponse(description: "AccountInvitation not found"),
        ]
    }
}

struct AccountInvitationResendOperation: AccountInvitationIDOperation {
    var responseMap: ResponseMap {
        [
            200: AccountInvitationDetailResponse().reference(),
            404: CustomResponse(description: "AccountInvitation not found"),
        ]
    }
}
