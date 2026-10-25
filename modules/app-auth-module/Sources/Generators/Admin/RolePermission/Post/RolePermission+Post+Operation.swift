import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension RolePermission.Post {

    struct Operation: RolePermission.Operation {
        var operationId: String? { "authRolePermissionCreate" }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                201: Response()
                    .reference()
            ]
        }
    }
}
