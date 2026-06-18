import Hummingbird

struct AdminListMediaAsset {
    let controller: any AdminListMediaAssetController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListMediaAssetDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListMediaAssetDefaultInteractor(
                        repository: AdminMediaAssetOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminListMediaAssetDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
