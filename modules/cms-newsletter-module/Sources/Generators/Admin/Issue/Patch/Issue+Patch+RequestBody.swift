import FeatherOpenAPI

extension Issue.Patch {
    struct RequestBody: JSONRequestBodyRepresentable {
        var openAPIIdentifier: String { "NewsletterIssuePatchRequestBody" }
        var schema = Schema().reference()
    }
}
