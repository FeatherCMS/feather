import FeatherOpenAPI

extension Asset.File.Resolve {
    struct RequestBody: JSONRequestBodyRepresentable {
        var openAPIIdentifier: String { "MediaAssetResolveRequestBody" }
        var schema: some SchemaRepresentable { RequestSchema().reference() }
    }
}
