import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Contact.Field.List {
    struct Operation: Contact.Field.Operation {
        var operationId: String? { "contactFieldList" }
        var parameters: [any ParameterRepresentable] {
            [Contact.Field.Parameters.FormFilter().reference()]
        }
        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
