import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

public struct AdminContact {
    let renderingEngine: any RenderingEngine

    public init(renderingEngine: any RenderingEngine) {
        self.renderingEngine = renderingEngine
    }

    public func route(on router: Router<DefaultRequestContext>) {
        let details = AdminContactFormDetails(renderingEngine: renderingEngine)
        AdminListContactForms(details: details).route(on: router)
        AdminAddContactForm(details: details).route(on: router)
        AdminEditContactForm(details: details).route(on: router)
        AdminGetContactForm(details: details).route(on: router)
        AdminRemoveContactForm(details: details).route(on: router)

        AdminListContactFormEmails(details: details).route(on: router)
        AdminAddContactFormEmail(details: details).route(on: router)
        AdminEditContactFormEmail(details: details).route(on: router)
        AdminRemoveContactFormEmail(details: details).route(on: router)

        AdminListContactFields(renderingEngine: renderingEngine)
            .route(on: router)
        AdminAddContactField(renderingEngine: renderingEngine)
            .route(on: router)
        AdminEditContactField(renderingEngine: renderingEngine)
            .route(on: router)
        AdminRemoveContactField(renderingEngine: renderingEngine)
            .route(on: router)
        AdminContactFormDetailsFields(renderingEngine: renderingEngine)
            .route(on: router)

        let submissions = AdminContactFormSubmissions(
            renderingEngine: renderingEngine
        )
        AdminListContactFormSubmissions(submissions: submissions)
            .route(on: router)
        AdminGetContactFormSubmission(submissions: submissions)
            .route(on: router)
        AdminEditContactFormSubmission(submissions: submissions)
            .route(on: router)
        AdminRemoveContactFormSubmissions(submissions: submissions)
            .route(on: router)
        AdminListContactSubmissions(renderingEngine: renderingEngine)
            .route(on: router)
        AdminRemoveContactSubmissions(renderingEngine: renderingEngine)
            .route(on: router)
    }
}
