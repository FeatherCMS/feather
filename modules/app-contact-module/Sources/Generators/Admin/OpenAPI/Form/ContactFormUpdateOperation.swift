import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct ContactFormUpdateOperation: ContactFormKeyOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        ContactFormCreateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: ContactFormResponse().reference(),
            404: CustomResponse(description: "Contact form not found"),
        ]
    }
}
