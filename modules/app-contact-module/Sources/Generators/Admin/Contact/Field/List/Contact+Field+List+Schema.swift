import FeatherOpenAPI

extension Contact.Field.List {
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "FormFieldListSchema" }
        var items: (any SchemaRepresentable)? {
            Contact.Field.Get.Schema().reference()
        }
    }

    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "FormFieldListResponse" }
        var description: String = "Contact form field list response"
        var schema = Schema().reference()
    }
}
