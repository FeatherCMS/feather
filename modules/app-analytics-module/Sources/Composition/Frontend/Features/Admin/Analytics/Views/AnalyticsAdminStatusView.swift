import FeatherWebAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct AnalyticsAdminStatusView: Component {
    let breadcrumb: [AdminBreadcrumb.Link]
    let title: String
    let message: String

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: breadcrumb))
            context.build(
                AdminStatusView(
                    state: .init(title: title, message: message),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }
        .class("cms-section")
    }
}
