import FeatherOpenAPI
import FeatherOpenAPIGenerator

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
