import SystemModule
import FeatherAdmin
import FeatherModuleKit
import Hummingbird
import WebComponents

struct AdminViewDesignSystemDefaultPresenter: AdminViewDesignSystemPresenter {

    let request: Request
    let context: AuthenticatedRequestContext
    let events: any EventPublisher
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminViewDesignSystemModel
    ) async throws -> HTMLResponse {
        var buildContext = BuilderContext()
        let menuGroups = try await adminMenuGroups(
            for: context,
            request: request,
            events: events
        )
        let layout = AdminBaseLayout(
            content: AdminViewDesignSystemComponent(),
            menuGroups: menuGroups
        )
        let component = AdminHTML(
            title: model.title,
            body: .init(content: layout)
        )
        return .init(buildContext.build(component))
    }
}
