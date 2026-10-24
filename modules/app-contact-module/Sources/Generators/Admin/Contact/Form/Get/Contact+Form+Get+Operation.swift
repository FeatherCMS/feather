import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Contact.Form.Get {
    struct Operation: Contact.Form.KeyOperation {
        var operationId: String? { "contactFormGet" }
        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "Contact form not found"),
            ]
        }
    }
}
