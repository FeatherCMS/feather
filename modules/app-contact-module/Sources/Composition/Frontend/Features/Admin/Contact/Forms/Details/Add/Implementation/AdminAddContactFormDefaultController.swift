import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddContactFormDefaultController: AdminAddContactFormController {
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminAddContactFormInteractor,
            any AdminAddContactFormPresenter
        >

    func add(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        let availableFields = (try? await interactor.availableFields()) ?? []
        return try await presenter.renderPage(
            item: .init(
                key: "",
                name: "",
                successMessage: "",
                failureMessage: "",
                redirectUrl: nil,
                selectedFieldIDs: [],
                availableFields: availableFields,
                mails: []
            ),
            error: nil,
            permissions: context.currentUserPermissions
        )
    }

    func create(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let (interactor, presenter) = buildRuntime((request, context))
        let form = try await request.decode(
            as: ContactFormEditForm.self,
            context: context
        )
        do {
            _ = try await interactor.create(
                key: form.key,
                name: form.name,
                successMessage: form.successMessage ?? "",
                failureMessage: form.failureMessage ?? "",
                redirectUrl: form.redirectUrl,
                fieldIDs: form.fieldIds ?? [],
                mails: form.mails
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminNotificationRedirect.location(
                        defaultPath: "/admin/contact/forms/",
                        title: "Added",
                        message: "Contact form added successfully."
                    )
                ]
            )
        }
        catch let error as AdminAddContactFormError {
            let availableFields =
                (try? await interactor.availableFields()) ?? []
            return
                try await presenter.renderAddError(
                    item: .init(
                        key: form.key,
                        name: form.name,
                        successMessage: form.successMessage ?? "",
                        failureMessage: form.failureMessage ?? "",
                        redirectUrl: form.redirectUrl,
                        selectedFieldIDs: form.fieldIds ?? [],
                        availableFields: availableFields,
                        mails: form.mails
                    ),
                    error: error,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
