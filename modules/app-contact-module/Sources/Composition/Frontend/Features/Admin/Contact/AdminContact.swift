public import FeatherAdmin
public import Hummingbird

public struct AdminContact {
    private let apiBuilder: ContactAPIBuilder
    public let renderingEngine: any RenderingEngine

    public init(
        apiBuilder: ContactAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.apiBuilder = apiBuilder
        self.renderingEngine = renderingEngine
    }

    public func route(on router: any RouterMethods<AuthenticatedRequestContext>)
    {
        AdminViewContactOverview(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListContactForms(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminAddContactForm(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminEditContactForm(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminViewContactForm(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminRemoveContactForm(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListContactFormEmails(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminAddContactFormEmail(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminEditContactFormEmail(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminRemoveContactFormEmail(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListContactFields(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminAddContactField(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminEditContactField(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminRemoveContactField(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminListContactFormSubmissions(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminViewContactFormSubmission(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminEditContactFormSubmission(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminRemoveContactFormSubmissions(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminListContactSubmissions(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminRemoveContactSubmissions(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
    }
}
