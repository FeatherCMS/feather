import AnalyticsSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct AnalyticsLogListResponse: JSONResponseRepresentable {
    var description: String = "AnalyticsLog list response"
    var schema = AnalyticsLogListSchema().reference()
}

struct AnalyticsLogDetailResponse: JSONResponseRepresentable {
    var description: String = "AnalyticsLog detail response"
    var schema = AnalyticsLogDetailSchema().reference()
}
