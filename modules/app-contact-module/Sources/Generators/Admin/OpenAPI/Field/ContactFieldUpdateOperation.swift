import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct ContactFieldUpdateOperation: ContactFieldIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        FormFieldPatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: FormFieldResponse().reference(),
            404: CustomResponse(description: "Contact field not found"),
        ]
    }
}
