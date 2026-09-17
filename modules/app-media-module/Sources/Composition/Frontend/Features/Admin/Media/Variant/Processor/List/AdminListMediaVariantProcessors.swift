import FeatherAdmin
import Hummingbird

struct AdminListMediaVariantProcessors {
    let controller: any AdminListMediaVariantProcessorsController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListMediaVariantProcessorsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor:
                        AdminListMediaVariantProcessorsDefaultInteractor(
                            repository:
                                AdminListMediaVariantProcessorsOpenAPIRepository(
                                    api: context.mediaAdminAPI()
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
