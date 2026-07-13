import Hummingbird

struct AdminContact {
    let renderingEngine: any RenderingEngine

    func route(on router: Router<AppRequestContext>) {
        AdminManageContactForms(renderingEngine: renderingEngine).controller.route(on: router)
        AdminManageContactFormItems(renderingEngine: renderingEngine).controller.route(on: router)
        AdminManageContactFormSubmissions(renderingEngine: renderingEngine).controller.route(on: router)
        AdminContactSubmissionsDirectory(renderingEngine: renderingEngine).controller.route(on: router)
        AdminAddContactFormItem(renderingEngine: renderingEngine).controller.route(on: router)
    }
}
