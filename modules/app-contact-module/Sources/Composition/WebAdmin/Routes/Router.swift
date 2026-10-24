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
        Contact.Overview
            .Router(
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)

        Form.Search
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        Form.Add
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        Form.Edit
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        Form.View
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        Form.Remove
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)

        SubmissionMail.List
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        SubmissionMail.Add
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        SubmissionMail.Edit
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        SubmissionMail.Remove
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)

        FormField.List
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        FormField.Add
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        FormField.Edit
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        FormField.Remove
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        Submission.Detail
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        Submission.Edit
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        Submission.Search
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        Submission.Remove
            .Router(
                environment: environment,
                routes: routes
            )
            .route(on: router)
    }
}
