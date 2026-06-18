import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

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
