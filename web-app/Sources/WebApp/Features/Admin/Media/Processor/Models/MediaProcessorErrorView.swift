import HTML
import SGML
import WebStandards

struct MediaProcessorErrorView: Component {
    let info: String
    let breadcrumb: AdminBreadcrumb.State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: breadcrumb)
            H1("Error")
            P(info)
        }
        .class("cms-section")
    }
}
