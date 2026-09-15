import FeatherAdmin
import Hummingbird

public struct AdminContact {
    public let renderingEngine: any RenderingEngine

    public init(renderingEngine: any RenderingEngine) {
        self.renderingEngine = renderingEngine
    }

    public func route(on router: Router<DefaultRequestContext>) {
        AdminViewContactOverview(renderingEngine: renderingEngine)
            .controller.route(on: router)

        AdminListContactForms(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminAddContactForm(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminEditContactForm(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminViewContactForm(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminRemoveContactForm(renderingEngine: renderingEngine)
            .controller.route(on: router)

        AdminListContactFormEmails(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminAddContactFormEmail(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminEditContactFormEmail(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminRemoveContactFormEmail(renderingEngine: renderingEngine)
            .controller.route(on: router)

        AdminListContactFields(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminAddContactField(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminEditContactField(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminRemoveContactField(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminListContactFormFields(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminAddContactFormField(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminEditContactFormField(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminRemoveContactFormField(renderingEngine: renderingEngine)
            .controller.route(on: router)

        AdminListContactFormSubmissions(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminViewContactFormSubmission(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminEditContactFormSubmission(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminRemoveContactFormSubmissions(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminListContactSubmissions(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminRemoveContactSubmissions(renderingEngine: renderingEngine)
            .controller.route(on: router)
    }
}
