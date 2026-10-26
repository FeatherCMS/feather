import FeatherOpenAPI

extension Page.ID.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "PageDetailResponse" }
        var description: String = "Web page detail"
        var schema: some SchemaRepresentable { PageDetailSchema().reference() }
    }
}
