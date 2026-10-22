import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct AppContactFormSubmissionOperation: OperationRepresentable {
    var tags: [any TagRepresentable] { [AppContactFormsTag()] }
    var parameters: [any ParameterRepresentable] {
        [AppContactFormKeyParameter().reference()]
    }
    var requestBody: (any RequestBodyRepresentable)? {
        AppContactFormSubmissionRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [201: AppContactFormSubmissionResponse().reference()]
    }
}
