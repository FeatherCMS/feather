import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol NewsletterCampaignOperation: BearerProtectedOperation {}

extension NewsletterCampaignOperation {
    var tags: [any TagRepresentable] { [NewsletterTag()] }
}
