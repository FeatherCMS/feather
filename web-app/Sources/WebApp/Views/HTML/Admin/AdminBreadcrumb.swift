import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminBreadcrumb: Component, FlowContent {

    struct State {

        struct Link {
            let label: String
            let link: String
        }

        let links: [Link]
    }

    let state: State

    func content() -> some BasicTag {
        Nav {
            Ol {
                for (idx, breadcrumb) in state.links.enumerated() {
                    if idx == state.links.count - 1 {
                        Li(breadcrumb.label).ariaCurrent(.page)
                    }
                    else {
                        Li { A(breadcrumb.label).href(breadcrumb.link) }
                    }
                }
            }
        }
        .class("cms-breadcrumb")
        .ariaLabel("Breadcrumb")
    }
}
