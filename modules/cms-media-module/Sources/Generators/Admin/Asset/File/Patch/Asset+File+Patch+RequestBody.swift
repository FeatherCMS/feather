import FeatherOpenAPI

extension Asset.File.Patch {
    struct RequestBody: JSONRequestBodyRepresentable {
        var openAPIIdentifier: String { "MediaAssetPatchRequestBody" }
        var schema: some SchemaRepresentable { Schema().reference() }
    }
}
