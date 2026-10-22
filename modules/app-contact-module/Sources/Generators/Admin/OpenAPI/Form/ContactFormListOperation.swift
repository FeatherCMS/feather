import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct ContactFormListOperation: ContactFormOperation {
    var responseMap: ResponseMap {
        [200: ContactFormListResponse().reference()]
    }
}
