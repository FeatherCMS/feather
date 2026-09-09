import FeatherAdmin
import Hummingbird
import FeatherContracts

struct AdminGetDesignSystemDefaultPresenter: AdminGetDesignSystemPresenter {

    let request: Request
    let context: DefaultRequestContext
    let events: any EventPublisher
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminGetDesignSystemModel
    ) async throws -> HTMLResponse {
        let menuGroups = try await context.adminMenuGroups(
            request: request,
            events: events
        )
        let layout = NewAdminBaseLayout(
            content: AdminGetDesignSystemComponent(),
            menuGroups: menuGroups
        )
        let component = NewAdminHTML(
            title: model.title,
            body: .init(content: layout)
        )
        return .init(component.html())
    }
}
