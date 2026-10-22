import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct MetadataQueryOperation: MetadataOperation {
    var operationId: String? { "metadataQuery" }
    var searchRequestQuery: SearchRequestQuerySchema {
        .init(
            items: MetadataQueryItemSchema(),
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
                    "referenceType": MetadataReferenceTypeField()
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
