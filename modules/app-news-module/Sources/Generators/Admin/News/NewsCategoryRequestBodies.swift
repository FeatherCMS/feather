import FeatherOpenAPI
import OpenAPIKit30

struct NewsCategoryRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [.json: Content(NewsCategoryCreateSchema().reference())]
    }
}

struct NewsCategoryUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [.json: Content(NewsCategoryCreateSchema().reference())]
    }
}
