import FeatherAdmin
import HTML
import SGML
import WebComponents
import WebBuilders

struct SystemJobError: Leaf {
    let message: String
    let breadcrumb: AdminBreadcrumb.State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: breadcrumb).renderHTML()
            H1("Unable to load worker jobs")
            P(message)
        }
        .class("cms-section")
    }
}
