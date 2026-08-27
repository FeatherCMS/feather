import FeatherAdmin
import Hummingbird

struct AdminListAuthSession {
    let controller: any AdminListAuthSessionController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListAuthSessionDefaultController(
            buildRuntime: { request, context in
                (
                    repository: AdminListAuthSessionOpenAPIRepository(
                        api: context.authAdminAPI()
                    ),
                    presenter: AdminListAuthSessionDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
