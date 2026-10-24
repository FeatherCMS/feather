import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Contact.Field.Put {
    struct Operation: Contact.Field.IDOperation {
        var operationId: String? { "contactFieldUpdate" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Contact.Field.Get.Response().reference(),
                404: CustomResponse(description: "Contact field not found"),
            ]
        }
    }
}
