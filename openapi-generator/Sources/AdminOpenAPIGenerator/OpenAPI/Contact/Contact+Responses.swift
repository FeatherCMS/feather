import FeatherOpenAPI

struct ContactFormResponse: JSONResponseRepresentable { var description: String = "Contact form response"; var schema = ContactFormSchema().reference() }
struct ContactFormListResponse: JSONResponseRepresentable { var description: String = "Contact form list response"; var schema = ContactFormListSchema().reference() }
struct ContactFormItemResponse: JSONResponseRepresentable { var description: String = "Contact form item response"; var schema = ContactFormItemSchema().reference() }
struct ContactFormItemListResponse: JSONResponseRepresentable { var description: String = "Contact form item list response"; var schema = ContactFormItemListSchema().reference() }
struct ContactFormSubmissionResponse: JSONResponseRepresentable { var description: String = "Contact form submission response"; var schema = ContactFormSubmissionSchema().reference() }
struct ContactFormSubmissionListResponse: JSONResponseRepresentable { var description: String = "Contact form submission list response"; var schema = ContactFormSubmissionListSchema().reference() }
struct ContactNewsletterResponse: JSONResponseRepresentable { var description: String = "Newsletter response"; var schema = ContactNewsletterSchema().reference() }
struct ContactNewsletterListResponse: JSONResponseRepresentable { var description: String = "Newsletter list response"; var schema = ContactNewsletterListSchema().reference() }
struct ContactNewsletterIssueResponse: JSONResponseRepresentable { var description: String = "Newsletter issue response"; var schema = ContactNewsletterIssueSchema().reference() }
struct ContactNewsletterIssueListResponse: JSONResponseRepresentable { var description: String = "Newsletter issue list response"; var schema = ContactNewsletterIssueListSchema().reference() }
struct ContactNewsletterDeliveryListResponse: JSONResponseRepresentable { var description: String = "Newsletter delivery list response"; var schema = ContactNewsletterDeliveryListSchema().reference() }
struct ContactNewsletterSubscriberListResponse: JSONResponseRepresentable { var description: String = "Newsletter subscriber list response"; var schema = ContactNewsletterSubscriberListSchema().reference() }
struct ContactNewsletterSubscriberResponse: JSONResponseRepresentable { var description: String = "Newsletter subscriber response"; var schema = ContactNewsletterSubscriberSchema().reference() }
