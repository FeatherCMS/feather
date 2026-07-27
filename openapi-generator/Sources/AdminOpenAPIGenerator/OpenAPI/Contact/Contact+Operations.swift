import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

protocol ContactFormOperation: BearerProtectedOperation {}
extension ContactFormOperation { var tags: [TagRepresentable] { [ContactFormsTag()] } }
protocol ContactFormIDOperation: ContactFormOperation {}
extension ContactFormIDOperation { var parameters: [ParameterRepresentable] { [ContactFormIdParameter().reference()] } }
protocol ContactFormItemOperation: ContactFormOperation {}
extension ContactFormItemOperation { var parameters: [ParameterRepresentable] { [ContactFormIdParameter().reference()] } }
protocol ContactFormItemIDOperation: ContactFormItemOperation {}
extension ContactFormItemIDOperation { var parameters: [ParameterRepresentable] { [ContactFormIdParameter().reference(), ContactFormItemIdParameter().reference()] } }
protocol ContactFormSubmissionOperation: ContactFormOperation {}
extension ContactFormSubmissionOperation { var parameters: [ParameterRepresentable] { [ContactFormIdParameter().reference()] } }
protocol ContactFormSubmissionIDOperation: ContactFormSubmissionOperation {}
extension ContactFormSubmissionIDOperation { var parameters: [ParameterRepresentable] { [ContactFormIdParameter().reference(), ContactFormSubmissionIdParameter().reference()] } }

struct ContactFormListOperation: ContactFormOperation { var responseMap: ResponseMap { [200: ContactFormListResponse().reference()] } }
struct ContactFormCreateOperation: ContactFormOperation { var requestBody: RequestBodyRepresentable? { ContactFormCreateRequestBody().reference() }; var responseMap: ResponseMap { [201: ContactFormResponse().reference()] } }
struct ContactFormGetOperation: ContactFormIDOperation { var responseMap: ResponseMap { [200: ContactFormResponse().reference(), 404: CustomResponse(description: "Contact form not found")] } }
struct ContactFormUpdateOperation: ContactFormIDOperation { var requestBody: RequestBodyRepresentable? { ContactFormCreateRequestBody().reference() }; var responseMap: ResponseMap { [200: ContactFormResponse().reference(), 404: CustomResponse(description: "Contact form not found")] } }
struct ContactFormDeleteOperation: ContactFormIDOperation { var responseMap: ResponseMap { [204: CustomResponse(description: "Contact form deleted"), 404: CustomResponse(description: "Contact form not found")] } }

struct ContactFormItemListOperation: ContactFormItemOperation { var responseMap: ResponseMap { [200: ContactFormItemListResponse().reference()] } }
struct ContactFormItemCreateOperation: ContactFormItemOperation { var requestBody: RequestBodyRepresentable? { ContactFormItemCreateRequestBody().reference() }; var responseMap: ResponseMap { [201: ContactFormItemResponse().reference()] } }
struct ContactFormItemGetOperation: ContactFormItemIDOperation { var responseMap: ResponseMap { [200: ContactFormItemResponse().reference(), 404: CustomResponse(description: "Contact form item not found")] } }
struct ContactFormItemUpdateOperation: ContactFormItemIDOperation { var requestBody: RequestBodyRepresentable? { ContactFormItemPatchRequestBody().reference() }; var responseMap: ResponseMap { [200: ContactFormItemResponse().reference(), 404: CustomResponse(description: "Contact form item not found")] } }
struct ContactFormItemDeleteOperation: ContactFormItemIDOperation { var responseMap: ResponseMap { [204: CustomResponse(description: "Contact form item deleted"), 404: CustomResponse(description: "Contact form item not found")] } }

struct ContactFormSubmissionListOperation: ContactFormSubmissionOperation { var responseMap: ResponseMap { [200: ContactFormSubmissionListResponse().reference()] } }
struct ContactFormSubmissionGetOperation: ContactFormSubmissionIDOperation { var responseMap: ResponseMap { [200: ContactFormSubmissionResponse().reference(), 404: CustomResponse(description: "Contact form submission not found")] } }
struct ContactFormSubmissionUpdateOperation: ContactFormSubmissionIDOperation { var requestBody: RequestBodyRepresentable? { ContactFormSubmissionPatchRequestBody().reference() }; var responseMap: ResponseMap { [200: ContactFormSubmissionResponse().reference(), 404: CustomResponse(description: "Contact form submission not found")] } }
struct ContactFormSubmissionDeleteOperation: ContactFormSubmissionIDOperation { var responseMap: ResponseMap { [204: CustomResponse(description: "Contact form submission deleted"), 404: CustomResponse(description: "Contact form submission not found")] } }

protocol ContactNewsletterOperation: BearerProtectedOperation {}
extension ContactNewsletterOperation { var tags: [TagRepresentable] { [ContactNewslettersTag()] } }
protocol ContactNewsletterIDOperation: ContactNewsletterOperation {}
extension ContactNewsletterIDOperation { var parameters: [ParameterRepresentable] { [ContactNewsletterIdParameter().reference()] } }
protocol ContactNewsletterIssueOperation: ContactNewsletterOperation {}
extension ContactNewsletterIssueOperation { var parameters: [ParameterRepresentable] { [ContactNewsletterIdParameter().reference()] } }
protocol ContactNewsletterIssueIDOperation: ContactNewsletterIssueOperation {}
extension ContactNewsletterIssueIDOperation { var parameters: [ParameterRepresentable] { [ContactNewsletterIdParameter().reference(), ContactNewsletterIssueIdParameter().reference()] } }
protocol ContactNewsletterSubscriberOperation: ContactNewsletterOperation {}
extension ContactNewsletterSubscriberOperation { var parameters: [ParameterRepresentable] { [ContactNewsletterIdParameter().reference()] } }
protocol ContactNewsletterSubscriberIDOperation: ContactNewsletterSubscriberOperation {}
extension ContactNewsletterSubscriberIDOperation { var parameters: [ParameterRepresentable] { [ContactNewsletterIdParameter().reference(), ContactNewsletterSubscriberEmailParameter().reference()] } }

struct ContactNewsletterListOperation: ContactNewsletterOperation { var responseMap: ResponseMap { [200: ContactNewsletterListResponse().reference()] } }
struct ContactNewsletterCreateOperation: ContactNewsletterOperation { var requestBody: RequestBodyRepresentable? { ContactNewsletterCreateRequestBody().reference() }; var responseMap: ResponseMap { [201: ContactNewsletterResponse().reference()] } }
struct ContactNewsletterGetOperation: ContactNewsletterIDOperation { var responseMap: ResponseMap { [200: ContactNewsletterResponse().reference(), 404: CustomResponse(description: "Newsletter not found")] } }
struct ContactNewsletterUpdateOperation: ContactNewsletterIDOperation { var requestBody: RequestBodyRepresentable? { ContactNewsletterPatchRequestBody().reference() }; var responseMap: ResponseMap { [200: ContactNewsletterResponse().reference(), 404: CustomResponse(description: "Newsletter not found")] } }
struct ContactNewsletterDeleteOperation: ContactNewsletterIDOperation { var responseMap: ResponseMap { [204: CustomResponse(description: "Newsletter deleted"), 404: CustomResponse(description: "Newsletter not found")] } }
struct ContactNewsletterIssueListOperation: ContactNewsletterIssueOperation { var responseMap: ResponseMap { [200: ContactNewsletterIssueListResponse().reference()] } }
struct ContactNewsletterIssueCreateOperation: ContactNewsletterIssueOperation { var requestBody: RequestBodyRepresentable? { ContactNewsletterIssueCreateRequestBody().reference() }; var responseMap: ResponseMap { [201: ContactNewsletterIssueResponse().reference()] } }
struct ContactNewsletterIssueGetOperation: ContactNewsletterIssueIDOperation { var responseMap: ResponseMap { [200: ContactNewsletterIssueResponse().reference(), 404: CustomResponse(description: "Newsletter issue not found")] } }
struct ContactNewsletterIssueUpdateOperation: ContactNewsletterIssueIDOperation { var requestBody: RequestBodyRepresentable? { ContactNewsletterIssuePatchRequestBody().reference() }; var responseMap: ResponseMap { [200: ContactNewsletterIssueResponse().reference(), 404: CustomResponse(description: "Newsletter issue not found")] } }
struct ContactNewsletterIssueDeleteOperation: ContactNewsletterIssueIDOperation { var responseMap: ResponseMap { [204: CustomResponse(description: "Newsletter issue deleted"), 404: CustomResponse(description: "Newsletter issue not found")] } }
struct ContactNewsletterIssueDeliveryListOperation: ContactNewsletterIssueIDOperation { var responseMap: ResponseMap { [200: ContactNewsletterDeliveryListResponse().reference(), 404: CustomResponse(description: "Newsletter issue not found")] } }
struct ContactNewsletterIssueTestEmailOperation: ContactNewsletterIssueIDOperation { var requestBody: RequestBodyRepresentable? { ContactNewsletterIssueTestEmailRequestBody().reference() }; var responseMap: ResponseMap { [204: CustomResponse(description: "Test email queued"), 404: CustomResponse(description: "Newsletter issue not found")] } }
struct ContactNewsletterTestEmailOperation: ContactNewsletterIssueOperation { var requestBody: RequestBodyRepresentable? { ContactNewsletterIssueTestEmailRequestBody().reference() }; var responseMap: ResponseMap { [204: CustomResponse(description: "Test email queued")] } }
struct ContactNewsletterSubscriberListOperation: ContactNewsletterSubscriberOperation { var responseMap: ResponseMap { [200: ContactNewsletterSubscriberListResponse().reference()] } }
struct ContactNewsletterSubscriberCreateOperation: ContactNewsletterSubscriberOperation { var requestBody: RequestBodyRepresentable? { ContactNewsletterSubscriberCreateRequestBody().reference() }; var responseMap: ResponseMap { [201: ContactNewsletterSubscriberResponse().reference()] } }
struct ContactNewsletterSubscriberGetOperation: ContactNewsletterSubscriberIDOperation { var responseMap: ResponseMap { [200: ContactNewsletterSubscriberResponse().reference(), 404: CustomResponse(description: "Newsletter subscriber not found")] } }
struct ContactNewsletterSubscriberUpdateOperation: ContactNewsletterSubscriberIDOperation { var requestBody: RequestBodyRepresentable? { ContactNewsletterSubscriberPatchRequestBody().reference() }; var responseMap: ResponseMap { [200: ContactNewsletterSubscriberResponse().reference(), 404: CustomResponse(description: "Newsletter subscriber not found")] } }
struct ContactNewsletterSubscriberDeleteOperation: ContactNewsletterSubscriberIDOperation { var responseMap: ResponseMap { [204: CustomResponse(description: "Newsletter subscriber deleted"), 404: CustomResponse(description: "Newsletter subscriber not found")] } }
