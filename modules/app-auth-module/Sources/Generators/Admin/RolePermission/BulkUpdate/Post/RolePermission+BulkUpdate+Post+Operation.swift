import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension RolePermission.BulkUpdate.Post {
    struct Operation: RolePermission.Operation {
        var operationId: String? { "authRolePermissionBulkUpdate" }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [204: NoContentResponse(description: "Role permissions updated")]
        }
    }
}
