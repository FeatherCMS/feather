import FeatherOpenAPI
import OpenAPIKit30

struct ContactFormCreateRequestBody: JSONRequestBodyRepresentable { var schema = ContactFormCreateSchema().reference() }
struct ContactFormItemCreateRequestBody: JSONRequestBodyRepresentable { var schema = ContactFormItemCreateSchema().reference() }
struct ContactFormItemPatchRequestBody: JSONRequestBodyRepresentable { var schema = ContactFormItemPatchSchema().reference() }
struct ContactFormSubmissionPatchRequestBody: JSONRequestBodyRepresentable { var schema = ContactFormSubmissionPatchSchema().reference() }
struct ContactNewsletterCreateRequestBody: JSONRequestBodyRepresentable { var schema = ContactNewsletterCreateSchema().reference() }
struct ContactNewsletterPatchRequestBody: JSONRequestBodyRepresentable { var schema = ContactNewsletterPatchSchema().reference() }
struct ContactNewsletterIssueCreateRequestBody: JSONRequestBodyRepresentable { var schema = ContactNewsletterIssueCreateSchema().reference() }
struct ContactNewsletterIssuePatchRequestBody: JSONRequestBodyRepresentable { var schema = ContactNewsletterIssuePatchSchema().reference() }
struct ContactNewsletterSubscriberCreateRequestBody: JSONRequestBodyRepresentable { var schema = ContactNewsletterSubscriberCreateSchema().reference() }
struct ContactNewsletterSubscriberPatchRequestBody: JSONRequestBodyRepresentable { var schema = ContactNewsletterSubscriberPatchSchema().reference() }
