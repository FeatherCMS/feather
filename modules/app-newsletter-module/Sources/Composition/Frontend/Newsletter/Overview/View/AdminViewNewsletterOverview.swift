import FeatherAdmin
import Hummingbird

struct AdminViewNewsletterOverview {
    let controller: any AdminViewNewsletterOverviewController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewNewsletterOverviewDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewNewsletterOverviewDefaultInteractor(),
                    presenter: AdminViewNewsletterOverviewDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
