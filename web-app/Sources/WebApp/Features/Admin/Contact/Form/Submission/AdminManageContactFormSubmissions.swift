import Hummingbird

struct AdminManageContactFormSubmissions {
    let controller: any AdminManageContactFormSubmissionsController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminManageContactFormSubmissionsDefaultController { request, context in
            (AdminManageContactFormSubmissionsDefaultInteractor(repository: .init(api: context.managementAPI())), AdminManageContactFormSubmissionsDefaultPresenter(request: request, renderEngine: renderingEngine))
        }
    }
}
