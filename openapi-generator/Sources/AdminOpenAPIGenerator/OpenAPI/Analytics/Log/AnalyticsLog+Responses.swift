import FeatherOpenAPI
import SharedOpenAPIComponents

struct AnalyticsLogFiltersResponse: JSONResponseRepresentable {
    var description: String = "AnalyticsLog filter response"
    var schema = AnalyticsLogFiltersSchema().reference()
}

struct AnalyticsLogDetailResponse: JSONResponseRepresentable {
    var description: String = "AnalyticsLog detail response"
    var schema = AnalyticsLogDetailSchema().reference()
}
