import Hummingbird

struct AdminRemoveMediaAsset {
    let controller: any AdminRemoveMediaAssetController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveMediaAssetDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveMediaAssetDefaultInteractor(
                        repository: AdminMediaAssetOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminRemoveMediaAssetDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
