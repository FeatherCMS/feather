import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Form.Add.Controller {
    struct Default: Interface {
        let routes: Contact.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Form.Add.Interactor.Interface,
                any Form.Add.Presenter.Interface
            >

        func add(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let availableFields =
                (try? await interactor.availableFields()) ?? []
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

        func create(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let form = try await request.decode(
                as: ContactFormEditForm.self,
                context: context
            )
            do {
                _ = try await interactor.create(
                    entity: .init(
                        key: form.key,
                        name: form.name,
                        successMessage: form.successMessage ?? "",
                        failureMessage: form.failureMessage ?? "",
                        redirectUrl: form.redirectUrl,
                        fieldIDs: form.fieldIds ?? [],
                        mails: form.mails.map {
                            .init(
                                id: "",
                                mailFrom: $0.mailFrom,
                                mailTo: $0.mailTo,
                                subject: $0.subject,
                                additionalHeaders: $0.additionalHeaders,
                                messageBody: $0.messageBody
                            )
                        }
                    )
                )
                return Response(
                    status: .seeOther,
                    headers: [
                        .location: AdminNotificationRedirect.location(
                            defaultPath: routes.forms.path,
                            title: "Added",
                            message: "Contact form added successfully."
                        )
                    ]
                )
            }
            catch let error as Form.Add.Error {
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
                            mails: form.mails.map {
                                .init(
                                    id: "",
                                    mailFrom: $0.mailFrom,
                                    mailTo: $0.mailTo,
                                    subject: $0.subject,
                                    additionalHeaders: $0.additionalHeaders,
                                    messageBody: $0.messageBody
                                )
                            }
                        ),
                        error: error,
                        permissions: context.currentUserPermissions
                    )
                    .response(from: request, context: context)
            }
        }

    }
}
