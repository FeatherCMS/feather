import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsCategoryCreateOperation: NewsCategoryOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        NewsCategoryRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [201: NewsCategoryDetailResponse().reference()]
    }
}
