import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Email.List {
    struct Operation: Email.Operation {
        var operationId: String? { "authEmailList" }

        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
