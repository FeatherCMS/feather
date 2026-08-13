import FeatherAdmin
import HTML
import SGML
import WebStandards

struct SystemJobError: Component {
    let message: String
    let breadcrumb: AdminBreadcrumb.State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: breadcrumb)
            H1("Unable to load worker jobs")
            P(message)
        }
        .class("cms-section")
    }
}
