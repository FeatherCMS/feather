import FeatherOpenAPI

extension Asset.File.Post.Parameters {
    struct Title: HeaderParameterRepresentable {
        var openAPIIdentifier: String { "MediaAssetTitleHeader" }
        var name: String { "X-Media-Asset-Title" }
        var required: Bool { false }
        var description: String? { "Optional asset title" }
        var schema: any OpenAPISchemaRepresentable { Asset.File.Schemas.HeaderValue() }
    }
}
