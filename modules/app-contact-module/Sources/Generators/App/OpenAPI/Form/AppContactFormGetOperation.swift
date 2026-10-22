import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct AppContactFormGetOperation: OperationRepresentable {
    var tags: [any TagRepresentable] { [AppContactFormsTag()] }
    var parameters: [any ParameterRepresentable] {
        [AppContactFormKeyParameter().reference()]
    }
    var responseMap: ResponseMap { [200: AppContactFormResponse().reference()] }
}
