import FeatherOpenAPI

extension Subscriber.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "NewsletterSubscriberResponse" }
        var description: String = "Newsletter subscriber response"
        var schema = Schema().reference()
    }
}
