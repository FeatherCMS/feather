import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Account.Create {
    struct Operation: BearerProtectedOperation {
        var operationId: String? { "accountCreate" }
        var tags: [any TagRepresentable] { [Tag()] }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [201: Response().reference()]
        }
    }
}
