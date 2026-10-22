import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct AuthRolePermissionCreateOperation: AuthRolePermissionOperation {
    var operationId: String? { "authRolePermissionCreate" }

    var requestBody: (any RequestBodyRepresentable)? {
        AuthRolePermissionRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [201: AuthRolePermissionDetailResponse().reference()]
    }
}
