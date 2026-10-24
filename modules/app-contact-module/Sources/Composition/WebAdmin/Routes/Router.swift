import ContactApplication
import ContactModule
public import FeatherWebAdmin
public import FeatherWebShared
public import Hummingbird

public struct Router {
    private let environment: AppEnvironment
    private let routes: Contact.Router.Routes
    public let renderingEngine: any RenderingEngine

    public init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        routes: Contact.Router.Routes = .standard
    ) {
        self.environment = environment
        self.renderingEngine = renderingEngine
        self.routes = routes
    }

    public func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        let formRoutes = Form.Router.Routes(
            root: routes.root,
            breadcrumb: routes.breadcrumb
        )
        let formFieldRoutes = FormField.Router.Routes(
            root: routes.root,
            breadcrumb: routes.breadcrumb
        )
        let submissionRoutes = Submission.Router.Routes(
            root: routes.root,
            breadcrumb: routes.breadcrumb
        )
        let submissionMailRoutes = SubmissionMail.Router.Routes(
            root: routes.root,
            breadcrumb: routes.breadcrumb
        )

        Contact.Overview
            .Router(
                renderingEngine: renderingEngine,
                routes: .init(
                    root: routes.root,
                    breadcrumb: routes.breadcrumb,
                    forms: formRoutes.forms,
                    fields: formFieldRoutes.fields,
                    submissions: submissionRoutes.submissions
                )
            )
            .route(on: router)

        Form.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: formRoutes
        )
        .route(on: router)

        FormField.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: formFieldRoutes
        )
        .route(on: router)

        Submission.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: submissionRoutes
        )
        .route(on: router)

        SubmissionMail.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: submissionMailRoutes
        )
        .route(on: router)
    }
}
