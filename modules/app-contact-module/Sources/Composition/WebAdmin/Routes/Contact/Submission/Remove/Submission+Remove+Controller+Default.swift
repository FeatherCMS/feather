import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Submission.Remove.Controller {
    struct Default: Interface {
        let routes: Contact.Router.Routes
        let buildInteractor:
            @Sendable (Request, AuthenticatedRequestContext) -> any Submission
                .Remove.Interactor.Interface

        func remove(request: Request, context: AuthenticatedRequestContext)
            async throws -> Response
        {
            let payload = try await decodePayload(request, context: context)
            try await buildInteractor(request, context)
                .remove(ids: payload.input.normalizedIds)

            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminListRemoveRedirect.location(
                        path: routes.submissions.path,
                        page: payload.input.normalizedPage,
                        search: payload.input.normalizedSearch,
                        title: "Removed",
                        message: "Contact submissions removed successfully."
                    )
                ]
            )
        }

        func removeForForm(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let formKey = try context.requiredParameter("formKey")
            let payload = try await decodePayload(request, context: context)
            try await buildInteractor(request, context)
                .remove(
                    formId: formKey,
                    ids: payload.input.normalizedIds
                )

            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminListRemoveRedirect.location(
                        path: routes.formSubmissions.path(
                            parameter: "formKey",
                            value: formKey
                        ),
                        page: payload.input.normalizedPage,
                        search: payload.input.normalizedSearch,
                        title: "Removed",
                        message:
                            "Contact form submissions removed successfully."
                    )
                ]
            )
        }

        private func decodePayload(
            _ request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> NonceRequest<AdminListRemoveFormInput> {
            let payload = try await request.decode(
                as: NonceRequest<AdminListRemoveFormInput>.self,
                context: context
            )
            guard
                await AdminNonceStore.shared.consume(
                    payload.nonce,
                    sessionToken: context.sessionToken
                )
            else { throw HTTPError(.badRequest) }
            return payload
        }
    }
}
