import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct AppContactFormsTag: TagRepresentable {
    var name: String = "ContactForms"
    var description: String? = "Public contact form endpoints."
}

struct AppContactFormResponse: JSONResponseRepresentable {
    var description: String = "Contact form response"
    var schema = AppContactFormSchema().reference()
}
struct AppContactFormSubmissionResponse: JSONResponseRepresentable {
    var description: String = "Contact form submission response"
    var schema = AppContactFormSubmissionResponseSchema().reference()
}
struct AppContactFormGetOperation: OperationRepresentable {
    var tags: [TagRepresentable] { [AppContactFormsTag()] }
    var parameters: [ParameterRepresentable] {
        [AppContactFormIdParameter().reference()]
    }
    var responseMap: ResponseMap { [200: AppContactFormResponse().reference()] }
}

struct AppContactFormSubmissionOperation: OperationRepresentable {
    var tags: [TagRepresentable] { [AppContactFormsTag()] }
    var parameters: [ParameterRepresentable] {
        [AppContactFormIdParameter().reference()]
    }
    var requestBody: RequestBodyRepresentable? {
        AppContactFormSubmissionRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [201: AppContactFormSubmissionResponse().reference()]
    }
}
