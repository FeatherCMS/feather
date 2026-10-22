import FeatherOpenAPI

extension Email.Get {
    struct Response: JSONResponseRepresentable {
        var description: String = "Auth email response"
        var schema = Email.Schemas.Detail().reference()
    }
}
