import AnalyticsSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol AnalyticsLogOperation: BearerProtectedOperation {}

extension AnalyticsLogOperation {
    var tags: [TagRepresentable] { [AnalyticsLogTag()] }
}

protocol AnalyticsLogIDOperation: AnalyticsLogOperation {}

extension AnalyticsLogIDOperation {
    var parameters: [ParameterRepresentable] {
        [
            AnalyticsLogIdParameter().reference()
        ]
    }
}

struct AnalyticsLogListOperation: AnalyticsLogOperation {
    var responseMap: ResponseMap {
        [
            200: AnalyticsLogListResponse().reference()
        ]
    }
}

struct AnalyticsLogSearchOperation: AnalyticsLogOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: AnalyticsLogListItemSchema(),
            sortFieldKeys: [
                "id",
                "accountId",
                "method",
                "source",
                "path",
                "responseCode",
                "ip",
                "browserName",
                "createdAt",
            ],
            filters: AnalyticsLogFilterSchema()
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

struct AnalyticsLogGetOperation: AnalyticsLogIDOperation {
    var responseMap: ResponseMap {
        [
            200: AnalyticsLogDetailResponse().reference(),
            404: CustomResponse(description: "AnalyticsLog not found"),
        ]
    }
}
