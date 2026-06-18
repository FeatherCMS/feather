import FeatherOpenAPI

struct MediaFolderDetailResponse: JSONResponseRepresentable {
    var description: String = "MediaFolder response"
    var schema: some SchemaRepresentable {
        MediaFolderDetailSchema().reference()
    }
}
