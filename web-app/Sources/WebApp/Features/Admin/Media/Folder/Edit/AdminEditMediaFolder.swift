import Hummingbird

struct AdminEditMediaFolder {
    let controller: any AdminEditMediaFolderController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditMediaFolderDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditMediaFolderDefaultInteractor(
                        repository: AdminEditMediaFolderOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminEditMediaFolderDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
