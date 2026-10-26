import FeatherOpenAPI

extension Page.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "PageDetailResponse" }
        var description: String = "Page response"
        var schema = Schema().reference()
    }
}
