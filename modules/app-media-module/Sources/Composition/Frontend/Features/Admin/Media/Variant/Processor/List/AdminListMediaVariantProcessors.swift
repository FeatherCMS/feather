import FeatherAdmin
import Hummingbird

struct AdminListMediaVariantProcessors {
    let controller: any AdminListMediaVariantProcessorsController

    init(
        apiBuilder: MediaAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminListMediaVariantProcessorsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor:
                        AdminListMediaVariantProcessorsDefaultInteractor(
                            repository:
                                AdminListMediaVariantProcessorsOpenAPIRepository(
                                    api: apiBuilder.makeMediaAdmin(context)
                                )
                        ),
                    presenter: AdminListMediaVariantProcessorsDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
