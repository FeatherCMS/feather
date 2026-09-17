import FeatherAdmin
import Hummingbird

struct AdminAddMediaVariant {
    let controller: any AdminAddMediaVariantController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddMediaVariantDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddMediaVariantDefaultInteractor(
                        repository: AdminAddMediaVariantOpenAPIRepository(
                            api: context.mediaAdminAPI()
                        )
                    ),
                    presenter: AdminAddMediaVariantDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
