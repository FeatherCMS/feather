import FeatherOpenAPI

extension Subscriber.List {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "NewsletterSubscriberListResponse" }
        var description: String = "Newsletter subscriber list response"
        var schema = Schema().reference()
    }
}
