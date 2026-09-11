import FeatherAdmin
import FeatherContracts
import Hummingbird
import SystemAdminAPI
import WebComponents

struct AdminAddSystemVariableDefaultPresenter:
    AdminAddSystemVariablePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let events: any EventPublisher

    func renderAddPage(
        state: SystemVariableAddForm.State
    ) async throws -> HTMLResponse {
        return try await renderPage(
            content: SystemVariableAddPage(
                breadcrumb: breadcrumb(),
                form: SystemVariableAddForm(
                    state: state,
                    action: SystemVariableRoutes.add.description,
                    submitLabel: "Add variable"
                )
            )
        )
    }

    private func renderPage<T: Component>(content: T) async throws -> HTMLResponse {
        try await SystemVariableAdminPageRenderer(
            request: request,
            context: context,
            events: events
        ).render(content: content)
    }

    private func breadcrumb() -> NewAdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "System", link: "/admin/system/"),
            .init(
                label: "Variables",
                link: SystemVariableRoutes.list.description
            ),
        ])
    }
}
