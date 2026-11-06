import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Analytics.Log.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogDetailResponse" }
        var description: String = "AnalyticsLog detail response"
        var schema = Schema().reference()
    }
}
