import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Asset.File.Post {
    struct Operation: Asset.File.Operation {
        var operationId: String? { "mediaAssetPost" }
        var parameters: [any ParameterRepresentable] {
            [
                Parameters.ParentID().reference(),
                Parameters.FileName().reference(),
                Parameters.Extension().reference(),
                Parameters.Title().reference(),
                Parameters.AltText().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                201: Asset.File.Get.Response().reference(),
                409: CustomResponse(
                    description: "A media asset with this path already exists"
                ),
            ]
        }
    }
}
