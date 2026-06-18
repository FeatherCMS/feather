import FeatherValidation
import HTML
import Hummingbird

struct AdminAddWebMenuDefaultController: AdminAddWebMenuController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddWebMenuInteractor,
            presenter: any AdminAddWebMenuPresenter
        )

    func getAddWebMenu(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        return runtime.presenter.renderAddPage(
            state: formState(),
            permissions: context.currentUserPermissions
        )
    }

    func postAddWebMenu(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        var lastPayload: WebMenuFormInput?

        do {
            let payload = try await request.decode(
                as: WebMenuFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            try await runtime.interactor.execute(input: payload)

            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/web/menus/",
                        title: "Added",
                        message: "Menu added successfully."
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
                key: lastPayload?.normalizedKey ?? "",
                name: lastPayload?.normalizedName ?? "",
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
                key: lastPayload?.normalizedKey ?? "",
                name: lastPayload?.normalizedName ?? "",
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
                key: lastPayload?.normalizedKey ?? "",
                name: lastPayload?.normalizedName ?? "",
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
        key: String = "",
        name: String = "",
        notes: String = ""
    ) -> WebMenuForm.State {
        .init(
            key: .init(key: "key", label: "Key", value: key, error: nil),
            name: .init(key: "name", label: "Name", value: name, error: nil),
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
