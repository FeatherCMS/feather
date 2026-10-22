import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct ContactFormSubmissionListOperation: ContactFormSubmissionOperation {
    var responseMap: ResponseMap {
        [200: ContactFormSubmissionListResponse().reference()]
    }
}
