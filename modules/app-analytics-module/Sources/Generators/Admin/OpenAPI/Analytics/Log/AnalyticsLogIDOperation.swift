import AnalyticsSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol AnalyticsLogIDOperation: AnalyticsLogOperation {}

extension AnalyticsLogIDOperation {
    var parameters: [any ParameterRepresentable] {
        [
            AnalyticsLogIdParameter().reference()
        ]
    }
}
