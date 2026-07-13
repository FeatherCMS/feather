import Hummingbird

struct AdminContactSubmissionsDirectory {
    let controller: any AdminContactSubmissionsDirectoryController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminContactSubmissionsDirectoryDefaultController { request, context in
            (
                AdminContactSubmissionsDirectoryDefaultInteractor(
                    repository: .init(api: context.managementAPI())
                ),
                AdminContactSubmissionsDirectoryDefaultPresenter(
                    request: request,
                    renderEngine: renderingEngine
                )
            )
        }
    }
}
