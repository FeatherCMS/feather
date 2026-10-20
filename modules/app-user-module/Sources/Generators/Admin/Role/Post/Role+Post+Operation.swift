import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Role.Post {
    struct Operation: Role.Operation {
        var operationId: String? { "userRolePost" }
        var requestBody: (any RequestBodyRepresentable)? {
            UserRoleRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: UserRoleDetailResponse().reference()]
        }
    }
}
