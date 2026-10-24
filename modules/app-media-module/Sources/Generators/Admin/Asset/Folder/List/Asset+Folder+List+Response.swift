import FeatherOpenAPI

extension Asset.Folder.List {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "MediaFolderListResponse" }
        var description: String = "Media folder list response"
        var schema = Schema().reference()
    }
}
