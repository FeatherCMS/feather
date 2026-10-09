import FeatherOpenAPI
import OpenAPIKit30

struct NewsArticleRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [.json: Content(NewsArticleCreateSchema().reference())]
    }
}

struct NewsArticleUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [.json: Content(NewsArticleCreateSchema().reference())]
    }
}
