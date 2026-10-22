import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct AppContactFormSubmissionResponse: JSONResponseRepresentable {
    var description: String = "Contact form submission response"
    var schema = AppContactFormSubmissionResponseSchema().reference()
}
