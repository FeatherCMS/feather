import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct ContactFormGetOperation: ContactFormKeyOperation {
    var responseMap: ResponseMap {
        [
            200: ContactFormResponse().reference(),
            404: CustomResponse(description: "Contact form not found"),
        ]
    }
}
