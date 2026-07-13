import Hummingbird

struct AdminNewsletterIssueList {
    let controller: any AdminNewsletterIssueListController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminNewsletterIssueListDefaultController { request, context in
            (
                AdminNewsletterIssueListDefaultInteractor(repository: .init(api: context.managementAPI())),
                AdminNewsletterIssueListDefaultPresenter(request: request, renderEngine: renderingEngine)
            )
        }
    }
}
