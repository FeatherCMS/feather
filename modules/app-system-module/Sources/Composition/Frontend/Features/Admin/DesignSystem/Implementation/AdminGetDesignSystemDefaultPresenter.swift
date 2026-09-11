import FeatherAdmin
import Hummingbird
import FeatherContracts
import WebComponents

struct AdminGetDesignSystemDefaultPresenter: AdminGetDesignSystemPresenter {

    let request: Request
    let context: DefaultRequestContext
    let events: any EventPublisher
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminGetDesignSystemModel
    ) async throws -> HTMLResponse {
        var renderContext = RenderContext()
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
        return .init(renderContext.render(component))
    }
}
