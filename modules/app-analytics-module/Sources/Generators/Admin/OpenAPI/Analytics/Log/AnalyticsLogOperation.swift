import AnalyticsSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol AnalyticsLogOperation: BearerProtectedOperation {}

extension AnalyticsLogOperation {
    var tags: [any TagRepresentable] { [AnalyticsLogTag()] }
}
