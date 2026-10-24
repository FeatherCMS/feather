import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Permission.List {

    struct Operation: Permission.Operation, BearerProtectedOperation {
        var operationId: String? { "systemPermissionList" }
        var parameters: [any ParameterRepresentable] {
            [
                Permission.Parameters.Search().reference(),
                Permission.Parameters.IDs().reference(),
                Permission.Parameters.Limit().reference(),
            ]
        }
        var responseMap: ResponseMap {
            [200: Permission.List.Response().reference()]
        }
    }

}
