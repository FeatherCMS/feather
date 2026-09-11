import FeatherAdmin
import FeatherContracts
import Hummingbird

struct AdminGetDesignSystem {
    let controller: any AdminGetDesignSystemController

    init(
        renderingEngine: any RenderingEngine,
        events: any EventPublisher
    ) {
        self.controller = AdminGetDesignSystemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetDesignSystemDefaultInteractor(

                        ),
                    presenter: AdminGetDesignSystemDefaultPresenter(
                        request: request,
                        context: context,
                        events: events,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
