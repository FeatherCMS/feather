import Hummingbird

struct AdminAddMediaAsset {
    let controller: any AdminAddMediaAssetController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddMediaAssetDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddMediaAssetDefaultInteractor(
                        repository: AdminMediaAssetOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminAddMediaAssetDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
