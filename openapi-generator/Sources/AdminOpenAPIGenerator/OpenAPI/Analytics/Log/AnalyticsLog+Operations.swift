import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

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

struct AnalyticsLogFiltersOperation: AnalyticsLogOperation {
    var responseMap: ResponseMap {
        [
            200: AnalyticsLogFiltersResponse().reference()
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
            filters: AnalyticsLogFiltersSchema()
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
