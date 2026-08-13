import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol NewsletterIssueOperation: NewsletterCampaignOperation {}
extension NewsletterIssueOperation {
    var parameters: [ParameterRepresentable] {
        [NewsletterCampaignIdParameter().reference()]
    }
}
protocol NewsletterIssueIDOperation: NewsletterIssueOperation {}
extension NewsletterIssueIDOperation {
    var parameters: [ParameterRepresentable] {
        [
            NewsletterCampaignIdParameter().reference(),
            NewsletterIssueIdParameter().reference(),
        ]
    }
}

struct NewsletterIssueListOperation: NewsletterIssueOperation {
    var responseMap: ResponseMap {
        [200: NewsletterIssueListResponse().reference()]
    }
}
struct NewsletterIssueCreateOperation: NewsletterIssueOperation {
    var requestBody: RequestBodyRepresentable? {
        NewsletterIssueCreateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [201: NewsletterIssueResponse().reference()]
    }
}
struct NewsletterIssueGetOperation: NewsletterIssueIDOperation {
    var responseMap: ResponseMap {
        [
            200: NewsletterIssueResponse().reference(),
            404: CustomResponse(description: "Newsletter issue not found"),
        ]
    }
}
struct NewsletterIssueUpdateOperation: NewsletterIssueIDOperation {
    var requestBody: RequestBodyRepresentable? {
        NewsletterIssuePatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: NewsletterIssueResponse().reference(),
            404: CustomResponse(description: "Newsletter issue not found"),
        ]
    }
}
struct NewsletterIssueDeleteOperation: NewsletterIssueIDOperation {
    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "Newsletter issue deleted"),
            404: CustomResponse(description: "Newsletter issue not found"),
        ]
    }
}
struct NewsletterIssueTestEmailOperation: NewsletterIssueIDOperation {
    var requestBody: RequestBodyRepresentable? {
        NewsletterIssueTestEmailRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "Test email queued"),
            404: CustomResponse(description: "Newsletter issue not found"),
        ]
    }
}
struct NewsletterCampaignTestEmailOperation: NewsletterIssueOperation {
    var requestBody: RequestBodyRepresentable? {
        NewsletterIssueTestEmailRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [204: CustomResponse(description: "Test email queued")]
    }
}
