import FeatherOpenAPI
import OpenAPIKit30

struct FormFieldCreateRequestBody: JSONRequestBodyRepresentable {
    var schema = FormFieldCreateSchema().reference()
}
struct FormFieldPatchRequestBody: JSONRequestBodyRepresentable {
    var schema = FormFieldPatchSchema().reference()
}
