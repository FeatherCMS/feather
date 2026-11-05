import FeatherOpenAPI

extension Asset.File.Post.Parameters {
    struct Extension: HeaderParameterRepresentable {
        var openAPIIdentifier: String { "MediaAssetExtensionHeader" }
        var name: String { "X-Media-Asset-Extension" }
        var description: String? { "Canonical file extension" }
        var schema: any OpenAPISchemaRepresentable {
            Asset.File.Schemas.HeaderValue()
        }
    }
}
