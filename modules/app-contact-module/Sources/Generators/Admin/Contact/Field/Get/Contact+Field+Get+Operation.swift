import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Contact.Field.Get {
    struct Operation: Contact.Field.IDOperation {
        var operationId: String? { "contactFieldGet" }
        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "Contact field not found"),
            ]
        }
    }
}
