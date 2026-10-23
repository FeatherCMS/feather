import ContactModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension SubmissionMail.Remove.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any SubmissionMail.Remove.Interactor.Interface,
                any SubmissionMail.Remove.Presenter.Interface
            >
        let routes: Contact.Router.Routes

        func remove(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> Response
        {
            let payload = try await request.decode(
                as: NonceRequest<AdminListRemoveFormInput>.self,
                context: context
            )
            let interactor = buildRuntime(request, context).interactor
            let formId = try context.requiredParameter("formKey")
            guard
                await AdminNonceStore.shared.consume(
                    payload.nonce,
                    sessionToken: context.sessionToken
                )
            else { return Response(status: .badRequest) }
            try await interactor.remove(
                id: formId,
                emailIds: payload.input.normalizedIds
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminListRemoveRedirect.location(
                        path: routes.formEmailsPath(formId),
                        page: payload.input.normalizedPage,
                        search: payload.input.normalizedSearch,
                        title: "Removed",
                        message: "Contact form emails removed successfully."
                    )
                ]
            )
        }
    }
}
