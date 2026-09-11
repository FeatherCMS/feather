import FeatherAdmin
import FeatherContracts
import Hummingbird
import WebComponents

struct SystemVariableAdminPageRenderer: Sendable {
    let request: Request
    let context: DefaultRequestContext
    let events: any EventPublisher

    func render<T: Component>(
        content: T,
        title: String = "Manage system variables"
    ) async throws -> HTMLResponse {
        let menuGroups = try await context.adminMenuGroups(
            request: request,
            events: events
        )
        let notification = AdminNotificationFlash.notification(from: request)
        var renderContext = RenderContext()
        let layout = NewAdminBaseLayout(
            content: content,
            menuGroups: menuGroups,
            notification: notification
        )
        return .init(renderContext.render(NewAdminHTML(
            title: title,
            body: .init(content: layout)
        )))
    }
}
