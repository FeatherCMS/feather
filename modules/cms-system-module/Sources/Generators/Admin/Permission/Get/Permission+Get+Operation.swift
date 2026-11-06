import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Permission.Get {
    struct Operation: Permission.IdentifiableOperation, BearerProtectedOperation
    {
        var operationId: String? { "systemPermissionGet" }
        var parameters: [any ParameterRepresentable] {
            [Permission.Parameters.ID().reference()]
        }
        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: DefaultHTTPErrorContentResponse(
                    description: "SystemPermission not found"
                ),
            ]
        }
    }
}
