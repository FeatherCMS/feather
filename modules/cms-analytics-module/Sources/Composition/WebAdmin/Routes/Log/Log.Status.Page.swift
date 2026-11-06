import AnalyticsModule
import FeatherWebAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

extension Log.Status {
    struct Page: WebComponents.Component {
        let breadcrumb: [AdminBreadcrumb.Link]
        let title: String
        let message: String

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: breadcrumb))
                context.build(
                    FeatherWebAdmin.AdminStatusView(
                        state: .init(title: title, message: message),
                        icon: FeatherIcons.alertCircle()
                    )
                )
            }
            .class("cms-section")
        }
    }
}
