import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Asset.Folder.Patch {
    struct Operation: Asset.Folder.IDOperation {
        var operationId: String? { "mediaFolderPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                MediaFolderIdParameter().reference(),
                MediaFolderUpdateMaskParameter().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            MediaFolderPatchRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: MediaFolderDetailResponse().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Invalid update mask"
                ),
                404: CustomResponse(description: "MediaFolder not found"),
            ]
        }
    }
}
