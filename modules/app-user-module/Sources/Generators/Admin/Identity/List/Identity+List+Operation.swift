import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Identity.List {
    struct Operation: Identity.Operation {
        var operationId: String? { "userIdentityList" }
        var parameters: [any ParameterRepresentable] {
            [
                Identity.Parameters.Search().reference(),
                Identity.Parameters.RoleFilter().reference(),
                Identity.Parameters.ListLimit().reference(),
            ]
        }
        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
