import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol NewsletterCampaignOperation: BearerProtectedOperation {}
extension NewsletterCampaignOperation {
    var tags: [TagRepresentable] { [NewsletterTag()] }
}
protocol NewsletterCampaignKeyOperation: NewsletterCampaignOperation {}
extension NewsletterCampaignKeyOperation {
    var parameters: [ParameterRepresentable] {
        [NewsletterCampaignKeyParameter().reference()]
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
struct NewsletterCampaignGetOperation: NewsletterCampaignKeyOperation {
    var responseMap: ResponseMap {
        [
            200: NewsletterCampaignResponse().reference(),
            404: CustomResponse(description: "Newsletter not found"),
        ]
    }
}
struct NewsletterCampaignUpdateOperation: NewsletterCampaignKeyOperation {
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
struct NewsletterCampaignRemoveOperation: NewsletterCampaignOperation,
    DeleteOperation
{
}
