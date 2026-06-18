import Hummingbird

struct AdminEditMediaAsset {
    let controller: any AdminEditMediaAssetController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditMediaAssetDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditMediaAssetDefaultInteractor(
                        repository: AdminMediaAssetOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminEditMediaAssetDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
