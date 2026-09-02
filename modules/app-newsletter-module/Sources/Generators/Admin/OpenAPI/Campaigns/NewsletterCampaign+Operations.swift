import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol NewsletterCampaignOperation: BearerProtectedOperation {}
extension NewsletterCampaignOperation {
    var tags: [TagRepresentable] { [NewsletterTag()] }
}
protocol NewsletterCampaignIDOperation: NewsletterCampaignOperation {}
extension NewsletterCampaignIDOperation {
    var parameters: [ParameterRepresentable] {
        [NewsletterCampaignIdParameter().reference()]
    }
}

struct NewsletterCampaignListOperation: NewsletterCampaignOperation {
    var responseMap: ResponseMap {
        [200: NewsletterCampaignListResponse().reference()]
    }
}
struct NewsletterCampaignCreateOperation: NewsletterCampaignOperation {
    var requestBody: RequestBodyRepresentable? {
        NewsletterCampaignCreateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [201: NewsletterCampaignResponse().reference()]
    }
}
struct NewsletterCampaignGetOperation: NewsletterCampaignIDOperation {
    var responseMap: ResponseMap {
        [
            200: NewsletterCampaignResponse().reference(),
            404: CustomResponse(description: "Newsletter not found"),
        ]
    }
}
struct NewsletterCampaignUpdateOperation: NewsletterCampaignIDOperation {
    var requestBody: RequestBodyRepresentable? {
        NewsletterCampaignPatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: NewsletterCampaignResponse().reference(),
            404: CustomResponse(description: "Newsletter not found"),
        ]
    }
}
struct NewsletterCampaignDeleteOperation: NewsletterCampaignOperation,
    DeleteOperation
{
}
