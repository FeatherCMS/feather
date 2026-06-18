import FeatherOpenAPI

struct MediaFolderCreateRequestBody: JSONRequestBodyRepresentable {
    var schema: some SchemaRepresentable {
        MediaFolderCreateSchema().reference()
    }
}

struct MediaFolderPatchRequestBody: JSONRequestBodyRepresentable {
    var schema: some SchemaRepresentable {
        MediaFolderPatchSchema().reference()
    }
}
