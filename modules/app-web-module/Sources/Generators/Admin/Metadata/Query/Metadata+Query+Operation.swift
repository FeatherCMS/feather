import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Metadata.Query {
    struct Operation: Metadata.Operation, BearerProtectedOperation {
        var operationId: String? { "metadataQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: ItemSchema(),
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
                        "referenceType": Metadata.Schemas.ReferenceType()
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
}
