import FeatherOpenAPI

extension Asset.File.Post {
    struct RequestBody: BinaryRequestBodyRepresentable {
        var openAPIIdentifier: String { "MediaAssetCreateRequestBody" }
    }
}
