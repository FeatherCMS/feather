import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct ContactFieldCreateOperation: ContactFieldOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        FormFieldCreateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [201: FormFieldResponse().reference()]
    }
}
