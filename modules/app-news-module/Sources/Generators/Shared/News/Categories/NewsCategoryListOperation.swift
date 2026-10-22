import FeatherOpenAPIGenerator
import OpenAPIKit30
public import FeatherOpenAPI

struct NewsCategoryListOperation: NewsCategoryOperation {
    var responseMap: ResponseMap {
        [200: NewsCategoryListResponse().reference()]
    }
}
