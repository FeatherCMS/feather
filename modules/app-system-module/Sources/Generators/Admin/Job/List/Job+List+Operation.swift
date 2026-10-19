import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Job.List {
    struct Operation: Job.Operation, BearerProtectedOperation {
        var operationId: String? { "systemJobList" }
        var parameters: [any ParameterRepresentable] {
            [
                Job.Parameters.PageSize().reference(),
                Job.Parameters.PageNumber().reference(),
            ]
        }
        var responseMap: ResponseMap {
            [200: Job.List.Response().reference()]
        }
    }
}
