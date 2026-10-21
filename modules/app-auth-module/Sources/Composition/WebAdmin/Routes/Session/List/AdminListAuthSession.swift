import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

struct AdminListAuthSession {
    let controller: any AdminListAuthSessionController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminListAuthSessionDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListAuthSessionDefaultInteractor(
                        repository: AdminListAuthSessionOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: AdminListAuthSessionDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
