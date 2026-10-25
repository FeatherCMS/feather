import FeatherOpenAPI

extension Asset.File.Post.Parameters {
    struct ParentID: HeaderParameterRepresentable {
        var openAPIIdentifier: String { "MediaAssetParentIDHeader" }
        var name: String { "X-Media-Asset-Parent-ID" }
        var required: Bool { false }
        var description: String? { "Optional parent folder id" }
        var schema: any OpenAPISchemaRepresentable { Asset.File.Schemas.HeaderValue() }
    }
}
