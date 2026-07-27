import Hummingbird

struct AdminNewsletterSubscribersDirectory {
    let controller: any AdminNewsletterSubscribersDirectoryController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminNewsletterSubscribersDirectoryDefaultController {
            request,
            context in
            (
                AdminNewsletterSubscribersDirectoryDefaultInteractor(
                    repository: .init(api: context.managementAPI())
                ),
                AdminNewsletterSubscribersDirectoryDefaultPresenter(
                    request: request,
                    renderEngine: renderingEngine
                )
            )
        }
    }
}
