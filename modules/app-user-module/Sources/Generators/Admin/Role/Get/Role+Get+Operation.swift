import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Role.Get {
    struct Operation: Role.IdentifiableOperation {
        var operationId: String? { "userRoleGet" }
        var responseMap: ResponseMap {
            [
                200: UserRoleDetailResponse().reference(),
                404: CustomResponse(description: "UserRole not found"),
            ]
        }
    }
}
