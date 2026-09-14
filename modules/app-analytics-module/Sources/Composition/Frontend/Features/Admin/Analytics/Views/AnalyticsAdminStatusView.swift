import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct AnalyticsAdminStatusView: Component {
    let breadcrumb: [NewAdminBreadcrumb.Link]
    let title: String
    let message: String

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: breadcrumb))
            context.render(
                NewAdminStatusView(
                    state: .init(title: title, message: message),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }
        .class("cms-section")
    }
}
