import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Asset.Folder.Patch {
    struct Operation: Asset.Folder.IDOperation {
        var operationId: String? { "mediaFolderPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                Asset.Folder.Parameters.ID().reference(),
                Asset.Folder.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Asset.Folder.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Invalid update mask"
                ),
                404: CustomResponse(description: "MediaFolder not found"),
            ]
        }
    }
}
