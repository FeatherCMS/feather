import FeatherOpenAPI

struct NewsletterSubscriberListResponse: JSONResponseRepresentable {
    var description: String = "Newsletter subscriber list response"
    var schema = NewsletterSubscriberListSchema().reference()
}
struct NewsletterSubscriberResponse: JSONResponseRepresentable {
    var description: String = "Newsletter subscriber response"
    var schema = NewsletterSubscriberSchema().reference()
}
