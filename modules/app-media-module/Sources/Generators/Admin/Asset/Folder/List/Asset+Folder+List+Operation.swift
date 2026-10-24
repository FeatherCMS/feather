import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Asset.Folder.List {
    struct Operation: Asset.Folder.Operation {
        var operationId: String? { "mediaFolderList" }
        var parameters: [any ParameterRepresentable] {
            [MediaFolderParentIDParameter().reference()]
        }
        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
