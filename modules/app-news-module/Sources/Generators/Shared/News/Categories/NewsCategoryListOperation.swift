public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsCategoryListOperation: NewsCategoryOperation {
    var responseMap: ResponseMap {
        [200: NewsCategoryListResponse().reference()]
    }
}
