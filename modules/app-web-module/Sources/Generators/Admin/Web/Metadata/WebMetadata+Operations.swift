public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public protocol WebMetadataOperation: BearerProtectedOperation {
}

extension WebMetadataOperation {
    public var tags: [any TagRepresentable] { [WebMetadataTag()] }
}

public protocol WebMetadataIDOperation: WebMetadataOperation {
}

extension WebMetadataIDOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            WebMetadataIdParameter().reference()
        ]
    }
}

struct WebMetadataCreateOperation: WebMetadataOperation {
    var requestBody: (any RequestBodyRepresentable)? {
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

    var requestBody: (any RequestBodyRepresentable)? {
        SearchRequestBody(query: searchQuery)
    }

    var responseMap: ResponseMap {
        [
            200: SearchResponse(query: searchQuery).reference()
        ]
    }
}

struct WebMetadataResolveOperation: WebMetadataOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        WebMetadataResolveRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: WebMetadataResolveResponse().reference()
        ]
    }
}

struct WebMetadataRemoveOperation: WebMetadataOperation, DeleteOperation {
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
    var requestBody: (any RequestBodyRepresentable)? {
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
    var requestBody: (any RequestBodyRepresentable)? {
        WebMetadataPatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: WebMetadataDetailResponse().reference(),
            404: CustomResponse(description: "WebMetadata not found"),
        ]
    }
}
