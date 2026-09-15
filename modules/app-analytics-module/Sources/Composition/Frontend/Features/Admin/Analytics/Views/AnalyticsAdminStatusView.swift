import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct AnalyticsAdminStatusView: Component {
    let breadcrumb: [NewAdminBreadcrumb.Link]
    let title: String
    let message: String

    func html(context: inout BuilderContext) -> some BasicTag {
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
