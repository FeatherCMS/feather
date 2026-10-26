import FeatherOpenAPI

extension Asset.File.Post.Parameters {
    struct AltText: HeaderParameterRepresentable {
        var openAPIIdentifier: String { "MediaAssetAltTextHeader" }
        var name: String { "X-Media-Asset-Alt-Text" }
        var required: Bool { false }
        var description: String? { "Optional alternative text" }
        var schema: any OpenAPISchemaRepresentable { Asset.File.Schemas.HeaderValue() }
    }
}
