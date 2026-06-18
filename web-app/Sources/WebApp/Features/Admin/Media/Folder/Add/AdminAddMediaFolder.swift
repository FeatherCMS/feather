import Hummingbird

struct AdminAddMediaFolder {
    let controller: any AdminAddMediaFolderController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddMediaFolderDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddMediaFolderDefaultInteractor(
                        repository: AdminAddMediaFolderOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminAddMediaFolderDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
