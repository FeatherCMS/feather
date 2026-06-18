import HTML
import SGML
import WebStandards

struct MediaAssetErrorView: Component {
    let info: String
    let message: String
    let breadcrumb: AdminBreadcrumb.State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: breadcrumb)
            H1("Error")
            P { Strong(info) }
            P(message)
        }
        .class("cms-section")
    }
}
