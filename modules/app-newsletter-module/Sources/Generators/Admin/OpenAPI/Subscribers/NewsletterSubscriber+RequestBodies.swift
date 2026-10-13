import FeatherOpenAPI
import OpenAPIKit30

struct NewsletterSubscriberCreateRequestBody: JSONRequestBodyRepresentable {
    var schema = NewsletterSubscriberCreateSchema().reference()
}
struct NewsletterSubscriberPatchRequestBody: JSONRequestBodyRepresentable {
    var schema = NewsletterSubscriberPatchSchema().reference()
}
