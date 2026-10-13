import FeatherAdmin
import Hummingbird

struct AdminEditMediaVariant {
    let controller: any AdminEditMediaVariantController

    init(
        apiBuilder: MediaAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditMediaVariantDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditMediaVariantDefaultInteractor(
                        repository: AdminEditMediaVariantOpenAPIRepository(
                            api: apiBuilder.makeMediaAdmin(context)
                        )
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
