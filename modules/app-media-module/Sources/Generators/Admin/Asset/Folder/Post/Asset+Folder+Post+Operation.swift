import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Asset.Folder.Post {
    struct Operation: Asset.Folder.Operation {
        var operationId: String? { "mediaFolderPost" }
        var requestBody: (any RequestBodyRepresentable)? {
            MediaFolderCreateRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                201: MediaFolderDetailResponse().reference(),
                409: CustomResponse(
                    description: "A media folder with this path already exists"
                ),
            ]
        }
    }
}
