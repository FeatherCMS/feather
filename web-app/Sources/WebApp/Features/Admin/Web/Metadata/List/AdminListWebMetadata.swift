import Hummingbird

struct AdminListWebMetadata {
    let controller: any AdminListWebMetadataController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListWebMetadataDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListWebMetadataDefaultInteractor(
                        repository: AdminListWebMetadataOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminListWebMetadataDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
