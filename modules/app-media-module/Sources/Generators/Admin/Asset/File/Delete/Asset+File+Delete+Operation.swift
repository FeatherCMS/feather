import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Asset.File.Delete {
    struct Operation: Asset.File.Operation, DeleteOperation {
        var operationId: String? { "mediaAssetDelete" }
    }
}
