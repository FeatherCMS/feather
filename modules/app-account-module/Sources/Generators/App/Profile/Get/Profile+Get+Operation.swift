import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Profile.Get {
    struct Operation: Profile.Operation {
        var operationId: String? { "accountProfileGet" }
        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
