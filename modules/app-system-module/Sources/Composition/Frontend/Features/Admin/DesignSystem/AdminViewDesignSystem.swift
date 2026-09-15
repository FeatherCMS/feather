import FeatherAdmin
import FeatherContracts
import Hummingbird

struct AdminViewDesignSystem {
    let controller: any AdminViewDesignSystemController

    init(
        renderingEngine: any RenderingEngine,
        events: any EventPublisher
    ) {
        self.controller = AdminViewDesignSystemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewDesignSystemDefaultInteractor(

                        ),
                    presenter: AdminViewDesignSystemDefaultPresenter(
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
