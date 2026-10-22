import FeatherOpenAPI

extension Email.List {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AuthEmailListResponse" }
        var description: String = "Auth email list response"
        var schema = Email.Schemas.List().reference()
    }
}
