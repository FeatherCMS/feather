import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct ContactFieldGetOperation: ContactFieldIDOperation {
    var responseMap: ResponseMap {
        [
            200: FormFieldResponse().reference(),
            404: CustomResponse(description: "Contact field not found"),
        ]
    }
}
