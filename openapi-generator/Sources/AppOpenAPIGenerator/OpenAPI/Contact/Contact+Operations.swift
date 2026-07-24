import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

struct AppContactFormsTag: TagRepresentable { var name: String = "ContactForms"; var description: String? = "Public contact form endpoints." }
struct AppContactNewslettersTag: TagRepresentable { var name: String = "Newsletters"; var description: String? = "Public newsletter endpoints." }

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
    var parameters: [ParameterRepresentable] { [AppContactFormIdParameter().reference()] }
    var responseMap: ResponseMap { [200: AppContactFormResponse().reference()] }
}

struct AppContactFormSubmissionOperation: OperationRepresentable {
    var tags: [TagRepresentable] { [AppContactFormsTag()] }
    var parameters: [ParameterRepresentable] { [AppContactFormIdParameter().reference()] }
    var requestBody: RequestBodyRepresentable? { AppContactFormSubmissionRequestBody().reference() }
    var responseMap: ResponseMap { [201: AppContactFormSubmissionResponse().reference()] }
}
struct AppContactNewsletterSubscribeOperation: OperationRepresentable {
    var tags: [TagRepresentable] { [AppContactNewslettersTag()] }
    var parameters: [ParameterRepresentable] { [AppContactNewsletterIdParameter().reference()] }
    var requestBody: RequestBodyRepresentable? { AppContactNewsletterSubscriptionRequestBody().reference() }
    var responseMap: ResponseMap { [204: CustomResponse(description: "Subscriber added")] }
}
struct AppContactNewsletterUnsubscribeOperation: OperationRepresentable {
    var tags: [TagRepresentable] { [AppContactNewslettersTag()] }
    var parameters: [ParameterRepresentable] { [AppContactNewsletterIdParameter().reference()] }
    var requestBody: RequestBodyRepresentable? { AppContactNewsletterSubscriptionRequestBody().reference() }
    var responseMap: ResponseMap { [204: CustomResponse(description: "Subscriber unsubscribed")] }
}
