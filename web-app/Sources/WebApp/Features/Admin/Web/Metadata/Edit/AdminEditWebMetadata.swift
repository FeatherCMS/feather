import Hummingbird

struct AdminEditWebMetadata {
    let controller: any AdminEditWebMetadataController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditWebMetadataDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditWebMetadataDefaultInteractor(
                        repository: AdminEditWebMetadataOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminEditWebMetadataDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
