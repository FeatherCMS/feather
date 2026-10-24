import FeatherOpenAPI

extension Contact.Form.List {
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "ContactFormListSchema" }
        var items: (any SchemaRepresentable)? {
            Contact.Form.Get.Schema().reference()
        }
    }

    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "ContactFormListResponse" }
        var description: String = "Contact form list response"
        var schema = Schema().reference()
    }
}
