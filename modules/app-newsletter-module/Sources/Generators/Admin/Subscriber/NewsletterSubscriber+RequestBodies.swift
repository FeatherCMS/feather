import FeatherOpenAPI

struct NewsletterSubscriberCreateRequestBody: JSONRequestBodyRepresentable {
    var schema = NewsletterSubscriberCreateSchema().reference()
}
struct NewsletterSubscriberPatchRequestBody: JSONRequestBodyRepresentable {
    var schema = NewsletterSubscriberPatchSchema().reference()
}
