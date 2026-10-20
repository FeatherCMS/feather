import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Role.Patch {
    struct Operation: Role.IdentifiableOperation {
        var operationId: String? { "userRolePatch" }
        var requestBody: (any RequestBodyRepresentable)? {
            UserRolePatchRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: UserRoleDetailResponse().reference(),
                404: CustomResponse(description: "UserRole not found"),
            ]
        }
    }
}
