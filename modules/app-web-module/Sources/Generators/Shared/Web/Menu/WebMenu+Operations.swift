public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol WebOperation: OperationRepresentable {}

extension WebOperation {
    public var tags: [any TagRepresentable] { [WebContentTag()] }
}

struct WebMenuListOperation: WebOperation {
    var responseMap: ResponseMap {
        [200: WebMenuListResponse().reference()]
    }
}

struct WebMenuGetByKeyOperation: WebOperation {
    var parameters: [any ParameterRepresentable] {
        [WebMenuKeyParameter().reference()]
    }

    var responseMap: ResponseMap {
        [
            200: WebMenuResponse().reference(),
            404: CustomResponse(description: "Web menu not found"),
        ]
    }
}
