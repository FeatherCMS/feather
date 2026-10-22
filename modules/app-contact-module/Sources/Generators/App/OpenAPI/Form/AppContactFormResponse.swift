import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct AppContactFormResponse: JSONResponseRepresentable {
    var description: String = "Contact form response"
    var schema = AppContactFormSchema().reference()
}
