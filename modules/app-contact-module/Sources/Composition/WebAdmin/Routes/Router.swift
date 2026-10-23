import ContactModule
public import ContactWebShared
public import FeatherWebAdmin
import FeatherWebShared
public import Hummingbird

public struct Router {
    private let apiBuilder: ContactAPIBuilder
    private let routes: Contact.Router.Routes
    public let renderingEngine: any RenderingEngine

    public init(
        apiBuilder: ContactAPIBuilder,
        renderingEngine: any RenderingEngine,
        routes: Contact.Router.Routes = .standard
    ) {
        self.apiBuilder = apiBuilder
        self.renderingEngine = renderingEngine
        self.routes = routes
    }

    public func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        Contact.Overview
            .Router(
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)

        Form.Search
            .Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        Form.Add
            .Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        AdminContactFormFieldsData(apiBuilder: apiBuilder)
            .route(on: router)
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

        SubmissionMail.List
            .Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        SubmissionMail.Add
            .Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        SubmissionMail.Edit
            .Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        SubmissionMail.Remove
            .Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)

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
        Submission.Search
            .Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .route(on: router)
        Submission.Remove
            .Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .route(on: router)
    }
}
