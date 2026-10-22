import AnalyticsSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol AnalyticsLogOverviewBaseOperation: BearerProtectedOperation {}

extension AnalyticsLogOverviewBaseOperation {
    var tags: [any TagRepresentable] { [AnalyticsLogTag()] }
}
