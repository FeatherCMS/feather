import Hummingbird

struct AdminGetMediaAsset {
    let controller: any AdminGetMediaAssetController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetMediaAssetDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetMediaAssetDefaultInteractor(
                        repository: AdminMediaAssetOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminGetMediaAssetDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
