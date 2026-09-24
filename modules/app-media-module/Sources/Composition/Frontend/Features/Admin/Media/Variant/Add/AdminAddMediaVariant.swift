import FeatherAdmin
import Hummingbird

struct AdminAddMediaVariant {
    let controller: any AdminAddMediaVariantController

    init(
        apiBuilder: MediaAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminAddMediaVariantDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddMediaVariantDefaultInteractor(
                        repository: AdminAddMediaVariantOpenAPIRepository(
                            api: apiBuilder.makeMediaAdmin(context)
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
