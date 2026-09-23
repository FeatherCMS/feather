import FeatherAdmin
import Hummingbird

struct AdminListAuthSession {
    let controller: any AdminListAuthSessionController

    init(apiBuilder: AuthAPIBuilder,
        renderingEngine: any RenderingEngine) {
        controller = AdminListAuthSessionDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListAuthSessionDefaultInteractor(
                        repository: AdminListAuthSessionOpenAPIRepository(
                            api: apiBuilder.makeAuthAdmin(context)
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
