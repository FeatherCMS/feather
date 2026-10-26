import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Contact.Form.Put {
    struct Operation: Contact.Form.KeyOperation {
        var operationId: String? { "contactFormUpdate" }
        var requestBody: (any RequestBodyRepresentable)? {
            Contact.Form.Post.RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Contact.Form.Get.Response().reference(),
                404: CustomResponse(description: "Contact form not found"),
            ]
        }
    }
}
