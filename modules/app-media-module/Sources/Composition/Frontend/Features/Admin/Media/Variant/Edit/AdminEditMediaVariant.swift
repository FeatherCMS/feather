import FeatherAdmin
import Hummingbird

struct AdminEditMediaVariant {
    let controller: any AdminEditMediaVariantController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditMediaVariantDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditMediaVariantDefaultInteractor(
                        repository: AdminEditMediaVariantOpenAPIRepository(api: context.mediaAdminAPI())
                    ),
                    presenter: AdminEditMediaVariantDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
