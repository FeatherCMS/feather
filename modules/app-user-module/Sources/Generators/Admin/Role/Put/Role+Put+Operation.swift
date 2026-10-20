import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Role.Put {
    struct Operation: Role.IdentifiableOperation {
        var operationId: String? { "userRolePut" }
        var requestBody: (any RequestBodyRepresentable)? {
            UserRoleUpdateRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: UserRoleDetailResponse().reference(),
                404: CustomResponse(description: "UserRole not found"),
            ]
        }
    }
}
