import FeatherOpenAPI

struct ContactFormIdParameter: PathParameterRepresentable { var name: String { "contactFormId" }; var schema: any OpenAPISchemaRepresentable { ContactIdField().reference() } }
struct ContactFormItemIdParameter: PathParameterRepresentable { var name: String { "contactFormItemId" }; var schema: any OpenAPISchemaRepresentable { ContactIdField().reference() } }
struct ContactFormSubmissionIdParameter: PathParameterRepresentable { var name: String { "contactFormSubmissionId" }; var schema: any OpenAPISchemaRepresentable { ContactIdField().reference() } }
struct ContactNewsletterIdParameter: PathParameterRepresentable { var name: String { "contactNewsletterId" }; var schema: any OpenAPISchemaRepresentable { ContactIdField().reference() } }
struct ContactNewsletterIssueIdParameter: PathParameterRepresentable { var name: String { "contactNewsletterIssueId" }; var schema: any OpenAPISchemaRepresentable { ContactIdField().reference() } }
struct ContactNewsletterSubscriberEmailParameter: PathParameterRepresentable { var name: String { "email" }; var schema: any OpenAPISchemaRepresentable { ContactEmailField().reference() } }
