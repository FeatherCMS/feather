import FeatherOpenAPI
import OpenAPIKit30

struct ContactFormCreateRequestBody: JSONRequestBodyRepresentable {
    var schema = ContactFormCreateSchema().reference()
}
