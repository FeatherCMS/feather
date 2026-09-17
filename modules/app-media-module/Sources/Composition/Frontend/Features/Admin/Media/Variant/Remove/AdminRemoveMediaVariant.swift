import FeatherAdmin
import Hummingbird

struct AdminRemoveMediaVariant {
    let controller: any AdminRemoveMediaVariantController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveMediaVariantDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveMediaVariantDefaultInteractor(
                        repository: AdminRemoveMediaVariantOpenAPIRepository(api: context.mediaAdminAPI())
                    ),
                    presenter: AdminRemoveMediaVariantDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
