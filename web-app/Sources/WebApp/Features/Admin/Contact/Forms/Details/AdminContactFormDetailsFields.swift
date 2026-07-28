import Hummingbird

struct AdminContactFormDetailsFields {
    let renderingEngine: any RenderingEngine

    func route(on router: Router<AppRequestContext>) {
        AdminListContactFormFields(renderingEngine: renderingEngine)
            .route(on: router)
        AdminAddContactFormField(renderingEngine: renderingEngine)
            .route(on: router)
        AdminEditContactFormField(renderingEngine: renderingEngine)
            .route(on: router)
        AdminRemoveContactFormField(renderingEngine: renderingEngine)
            .route(on: router)
    }
}
