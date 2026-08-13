import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol NewsArticleOperation: OperationRepresentable {}

extension NewsArticleOperation {
    public var tags: [TagRepresentable] { [NewsContentTag()] }
}

struct NewsArticleListOperation: NewsArticleOperation {
    var responseMap: ResponseMap {
        [200: NewsArticleListResponse().reference()]
    }
}

struct NewsArticleGetOperation: NewsArticleOperation {
    var parameters: [ParameterRepresentable] {
        [NewsArticleIdParameter().reference()]
    }

    var responseMap: ResponseMap {
        [
            200: NewsArticleDetailResponse().reference(),
            404: CustomResponse(description: "News item not found"),
        ]
    }
}
