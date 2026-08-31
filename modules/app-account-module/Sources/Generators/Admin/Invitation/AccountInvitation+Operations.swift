import AccountSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol AccountInvitationOperation: BearerProtectedOperation {
}

extension AccountInvitationOperation {
    public var tags: [TagRepresentable] { [AccountInvitationTag()] }
}

public protocol AccountInvitationIDOperation: AccountInvitationOperation {
}

extension AccountInvitationIDOperation {
    public var parameters: [ParameterRepresentable] {
        [
            AccountInvitationIdParameter().reference()
        ]
    }
}

struct AccountInvitationCreateOperation: AccountInvitationOperation {
    var requestBody: RequestBodyRepresentable? {
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

struct AccountInvitationFiltersOperation: AccountInvitationOperation {
    var responseMap: ResponseMap {
        [
            200: AccountInvitationFiltersResponse().reference()
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

    var requestBody: RequestBodyRepresentable? {
        SearchRequestBody(query: searchQuery)
    }

    var responseMap: ResponseMap {
        [
            200: SearchResponse(query: searchQuery).reference()
        ]
    }
}

struct AccountInvitationBulkDeleteOperation: AccountInvitationOperation,
    BulkDeleteOperation
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
    var requestBody: RequestBodyRepresentable? {
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
    var requestBody: RequestBodyRepresentable? {
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
            404: CustomResponse(description: "AccountInvitation not found")
        ]
    }
}
