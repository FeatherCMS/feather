import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Tag.List {
    struct Operation: Tag.Operation {
        var operationId: String? { "blogTagList" }
        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
