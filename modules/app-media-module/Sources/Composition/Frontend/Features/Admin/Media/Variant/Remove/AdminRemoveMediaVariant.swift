import FeatherAdmin

struct AdminRemoveMediaVariant {
    let controller: any AdminRemoveMediaVariantController

    init(
        apiBuilder: MediaAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminRemoveMediaVariantDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveMediaVariantDefaultInteractor(
                        repository: AdminRemoveMediaVariantOpenAPIRepository(
                            api: apiBuilder.makeMediaAdmin(context)
                        )
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
