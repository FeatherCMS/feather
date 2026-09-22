import FeatherAdmin
import Hummingbird
import FeatherContracts
import WebComponents

struct AdminViewDesignSystemDefaultPresenter: AdminViewDesignSystemPresenter {

    let request: Request
    let context: DefaultRequestContext
    let events: any EventPublisher
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminViewDesignSystemModel
    ) async throws -> HTMLResponse {
        var buildContext = BuilderContext()
        let menuGroups = try await context.adminMenuGroups(
            request: request,
            events: events
        )
        let layout = NewAdminBaseLayout(
            content: AdminViewDesignSystemComponent(),
            menuGroups: menuGroups
        )
        let component = NewAdminHTML(
            title: model.title,
            body: .init(content: layout)
        )
        return .init(buildContext.build(component))
    }
}
