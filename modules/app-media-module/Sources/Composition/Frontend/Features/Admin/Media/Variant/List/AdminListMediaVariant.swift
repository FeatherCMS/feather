import FeatherAdmin
import Hummingbird

struct AdminListMediaVariant {
    static let pageSize = 20
    let controller: any AdminListMediaVariantController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListMediaVariantDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListMediaVariantDefaultInteractor(
                        repository: AdminListMediaVariantOpenAPIRepository(
                            api: context.mediaAdminAPI()
                        )
                    ),
                    presenter: AdminListMediaVariantDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
