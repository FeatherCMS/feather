import AnalyticsSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol AnalyticsLogOverviewBaseOperation: BearerProtectedOperation {}

extension AnalyticsLogOverviewBaseOperation {
    var tags: [TagRepresentable] { [AnalyticsLogTag()] }
}

struct AnalyticsLogOverviewOperation: AnalyticsLogOverviewBaseOperation {
    var requestBody: RequestBodyRepresentable? {
        AnalyticsLogOverviewRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: AnalyticsLogOverviewResponse().reference()
        ]
    }
}
