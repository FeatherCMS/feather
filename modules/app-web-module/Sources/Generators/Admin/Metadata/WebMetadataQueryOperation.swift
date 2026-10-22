import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

struct WebMetadataQueryOperation: WebMetadataOperation {
    var operationId: String? { "webMetadataQuery" }
    var searchRequestQuery: SearchRequestQuerySchema {
        .init(
            items: WebMetadataQueryItemSchema(),
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
        SearchRequestBody(query: searchRequestQuery)
    }

    var responseMap: ResponseMap {
        [
            200: SearchResponse(
                query: SearchResponseQuerySchema(query: searchRequestQuery)
            )
            .reference()
        ]
    }
}
