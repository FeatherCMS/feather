import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Role.List {
    struct Operation: Role.Operation {
        var operationId: String? { "userRoleList" }
        var parameters: [any ParameterRepresentable] {
            [
                Role.Parameters.Search().reference(),
                Role.Parameters.ListLimit().reference(),
            ]
        }
        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
