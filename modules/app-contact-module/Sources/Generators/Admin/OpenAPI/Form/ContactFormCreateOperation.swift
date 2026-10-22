import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct ContactFormCreateOperation: ContactFormOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        ContactFormCreateRequestBody().reference()
    }
    var responseMap: ResponseMap { [201: ContactFormResponse().reference()] }
}
