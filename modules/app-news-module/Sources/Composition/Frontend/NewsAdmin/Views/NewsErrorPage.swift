import FeatherAdmin
import HTML
import WebBuilders
import WebComponents

struct NewsErrorPage: Component {
    let breadcrumb: [NewAdminBreadcrumb.Link]
    let title: String
    let message: String

    func html(
        context: inout BuilderContext
    ) -> Section {
        Section {
            context.build(NewAdminBreadcrumb(links: breadcrumb))
            context.build(
                NewAdminStatusView(
                    state: .init(title: title, message: message),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }
        .class("cms-section")
    }
}
