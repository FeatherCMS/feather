import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Asset.Folder.Get {
    struct Operation: Asset.Folder.IDOperation {
        var operationId: String? { "mediaFolderGet" }
        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "MediaFolder not found"),
            ]
        }
    }
}
