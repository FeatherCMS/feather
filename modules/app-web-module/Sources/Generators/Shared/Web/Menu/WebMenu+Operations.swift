import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol WebOperation: OperationRepresentable {}

extension WebOperation {
    public var tags: [TagRepresentable] { [WebContentTag()] }
}

struct WebMenuListOperation: WebOperation {
    var responseMap: ResponseMap {
        [200: WebMenuListResponse().reference()]
    }
}
