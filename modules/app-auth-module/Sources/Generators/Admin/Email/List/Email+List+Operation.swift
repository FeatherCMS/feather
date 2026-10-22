import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Email.List {
    struct Operation: Email.Operation {
        var operationId: String? { "authEmailList" }

        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }

    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AuthEmailListResponse" }
        var description: String = "Auth email list response"
        var schema = Email.Schemas.List().reference()
    }
}
