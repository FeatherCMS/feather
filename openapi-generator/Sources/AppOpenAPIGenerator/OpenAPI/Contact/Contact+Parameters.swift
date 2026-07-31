import FeatherOpenAPI

struct AppContactFormIdParameter: PathParameterRepresentable { var name: String { "contactFormId" }; var schema: any OpenAPISchemaRepresentable { AppContactIdField().reference() } }
struct AppContactNewsletterIdParameter: PathParameterRepresentable { var name: String { "contactNewsletterId" }; var schema: any OpenAPISchemaRepresentable { AppContactIdField().reference() } }
