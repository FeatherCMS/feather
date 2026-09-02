import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public protocol WebMetadataOperation: BearerProtectedOperation {
}

extension WebMetadataOperation {
    public var tags: [TagRepresentable] { [WebMetadataTag()] }
}

public protocol WebMetadataIDOperation: WebMetadataOperation {
}

extension WebMetadataIDOperation {
    public var parameters: [ParameterRepresentable] {
        [
            WebMetadataIdParameter().reference()
        ]
    }
}

struct WebMetadataCreateOperation: WebMetadataOperation {
    var requestBody: RequestBodyRepresentable? {
        WebMetadataRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            201: WebMetadataDetailResponse().reference()
        ]
    }
}

struct WebMetadataListOperation: WebMetadataOperation {
    var responseMap: ResponseMap {
        [
            200: WebMetadataListResponse().reference()
        ]
    }
}

struct WebMetadataSearchOperation: WebMetadataOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: WebMetadataListItemSchema(),
            sortFieldKeys: [
                "id",
                "slug",
                "publicationDate",
                "expirationDate",
                "status",
                "title",
                "createdAt",
                "updatedAt",
            ],
            filters: SearchFilterSchema(
                additionalProperties: [
                    "referenceType": WebMetadataReferenceTypeField()
                        .reference(required: false)
                ]
            )
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

struct WebMetadataDeleteOperation: WebMetadataOperation, DeleteOperation {
}

struct WebMetadataGetOperation: WebMetadataIDOperation {
    var responseMap: ResponseMap {
        [
            200: WebMetadataDetailResponse().reference(),
            404: CustomResponse(description: "WebMetadata not found"),
        ]
    }
}

struct WebMetadataUpdateOperation: WebMetadataIDOperation {
    var requestBody: RequestBodyRepresentable? {
        WebMetadataUpdateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: WebMetadataDetailResponse().reference(),
            404: CustomResponse(description: "WebMetadata not found"),
        ]
    }
}

struct WebMetadataPatchOperation: WebMetadataIDOperation {
    var requestBody: RequestBodyRepresentable? {
        WebMetadataPatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: WebMetadataDetailResponse().reference(),
            404: CustomResponse(description: "WebMetadata not found"),
        ]
    }
}
