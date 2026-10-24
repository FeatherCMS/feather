import FeatherOpenAPI

extension Contact.Form.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AppContactFormResponse" }
        var description: String = "Contact form response"
        var schema = Schema().reference()
    }
}
