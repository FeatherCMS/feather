import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

public protocol UserInvitationOperation: BearerProtectedOperation {
}

extension UserInvitationOperation {
    public var tags: [TagRepresentable] { [UserInvitationTag()] }
}

public protocol UserInvitationIDOperation: UserInvitationOperation {
}

extension UserInvitationIDOperation {
    public var parameters: [ParameterRepresentable] {
        [
            UserInvitationIdParameter().reference()
        ]
    }
}

struct UserInvitationCreateOperation: UserInvitationOperation {
    var requestBody: RequestBodyRepresentable? {
        UserInvitationRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            201: UserInvitationDetailResponse().reference()
        ]
    }
}

struct UserInvitationListOperation: UserInvitationOperation {
    var responseMap: ResponseMap {
        [
            200: UserInvitationListResponse().reference()
        ]
    }
}

struct UserInvitationFiltersOperation: UserInvitationOperation {
    var responseMap: ResponseMap {
        [
            200: UserInvitationFiltersResponse().reference()
        ]
    }
}

struct UserInvitationSearchOperation: UserInvitationOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: UserInvitationListItemSchema(),
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

struct UserInvitationBulkDeleteOperation: UserInvitationOperation,
    BulkDeleteOperation
{
}

struct UserInvitationGetOperation: UserInvitationIDOperation {
    var responseMap: ResponseMap {
        [
            200: UserInvitationDetailResponse().reference(),
            404: CustomResponse(description: "UserInvitation not found"),
        ]
    }
}

struct UserInvitationUpdateOperation: UserInvitationIDOperation {
    var requestBody: RequestBodyRepresentable? {
        UserInvitationUpdateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: UserInvitationDetailResponse().reference(),
            404: CustomResponse(description: "UserInvitation not found"),
        ]
    }
}

struct UserInvitationPatchOperation: UserInvitationIDOperation {
    var requestBody: RequestBodyRepresentable? {
        UserInvitationPatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: UserInvitationDetailResponse().reference(),
            404: CustomResponse(description: "UserInvitation not found"),
        ]
    }
}

struct UserInvitationDeleteOperation: UserInvitationIDOperation {
    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "UserInvitation deleted"),
            404: CustomResponse(description: "UserInvitation not found"),
        ]
    }
}
