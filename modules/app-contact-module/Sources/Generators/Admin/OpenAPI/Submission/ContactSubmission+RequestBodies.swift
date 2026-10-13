import FeatherOpenAPI
import OpenAPIKit30

struct ContactFormSubmissionPatchRequestBody: JSONRequestBodyRepresentable {
    var schema = ContactFormSubmissionPatchSchema().reference()
}
