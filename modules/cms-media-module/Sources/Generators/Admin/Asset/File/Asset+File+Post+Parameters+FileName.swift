import FeatherOpenAPI

extension Asset.File.Post.Parameters {
    struct FileName: HeaderParameterRepresentable {
        var openAPIIdentifier: String { "MediaAssetFileNameHeader" }
        var name: String { "X-Media-Asset-File-Name" }
        var description: String? { "Original file name" }
        var schema: any OpenAPISchemaRepresentable {
            Asset.File.Schemas.HeaderValue()
        }
    }
}
