import FeatherValidation
import HTML
import Hummingbird

struct AdminAddRedirectRuleDefaultController: AdminAddRedirectRuleController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddRedirectRuleInteractor,
            presenter: any AdminAddRedirectRulePresenter
        )

    func getAddRedirectRule(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        return runtime.presenter.renderAddPage(
            state: formState(),
            permissions: context.currentUserPermissions
        )
    }

    func postAddRedirectRule(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        var lastPayload: RedirectRuleFormInput?

        do {
            let payload = try await request.decode(
                as: RedirectRuleFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            guard [301, 302, 307, 308].contains(payload.parsedStatusCode ?? -1)
            else {
                var state = formState(
                    source: payload.normalizedSource,
                    destination: payload.normalizedDestination,
                    statusCode: payload.normalizedStatusCode,
                    notes: payload.normalizedNotes
                )
                state.apply(errors: [
                    "statusCode": "Status code must be 301, 302, 307, or 308."
                ])
                return try runtime.presenter
                    .renderAddPage(
                        state: state,
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }
            try await runtime.interactor.execute(input: payload)

            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/redirect/rules/",
                        title: "Added",
                        message: "Redirect rule added successfully."
                    )
                ]
            )
        }
        catch let error as ValidationError {
            var errors: [String: String] = [:]
            for failure in error.failures {
                errors[failure.key] = failure.message
            }
            var state = formState(
                source: lastPayload?.normalizedSource ?? "",
                destination: lastPayload?.normalizedDestination ?? "",
                statusCode: lastPayload?.normalizedStatusCode ?? "301",
                notes: lastPayload?.normalizedNotes ?? ""
            )
            state.apply(errors: errors)
            return try runtime.presenter
                .renderAddPage(
                    state: state,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
        catch let error as OpenAPIRepositoryError {
            var state = formState(
                source: lastPayload?.normalizedSource ?? "",
                destination: lastPayload?.normalizedDestination ?? "",
                statusCode: lastPayload?.normalizedStatusCode ?? "301",
                notes: lastPayload?.normalizedNotes ?? ""
            )
            state.error = error.errorDescription
            return try runtime.presenter
                .renderAddPage(
                    state: state,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
        catch {
            var state = formState(
                source: lastPayload?.normalizedSource ?? "",
                destination: lastPayload?.normalizedDestination ?? "",
                statusCode: lastPayload?.normalizedStatusCode ?? "301",
                notes: lastPayload?.normalizedNotes ?? ""
            )
            state.error = error.displayMessage
            return try runtime.presenter
                .renderAddPage(
                    state: state,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
    }

    private func formState(
        source: String = "",
        destination: String = "",
        statusCode: String = "301",
        notes: String = ""
    ) -> RedirectRuleForm.State {
        .init(
            source: .init(
                key: "source",
                label: "Source path",
                value: source,
                error: nil
            ),
            destination: .init(
                key: "destination",
                label: "Destination URL or path",
                value: destination,
                error: nil
            ),
            statusCode: .init(
                key: "statusCode",
                label: "HTTP status code",
                value: statusCode,
                error: nil
            ),
            notes: .init(
                key: "notes",
                label: "Notes",
                value: notes,
                error: nil
            ),
            error: nil,
            success: nil
        )
    }
}
