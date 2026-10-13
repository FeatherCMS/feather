import FeatherOpenAPI

struct NewsletterDeliveryListResponse: JSONResponseRepresentable {
    var description: String = "Newsletter delivery list response"
    var schema = NewsletterDeliveryListSchema().reference()
}
