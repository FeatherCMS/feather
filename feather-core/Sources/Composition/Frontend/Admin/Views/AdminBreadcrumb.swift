import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

public struct AdminBreadcrumb: Component, FlowContent {

    public struct State: Sendable {

        public struct Link: Sendable {
            public let label: String
            public let link: String

            public init(label: String, link: String) {
                self.label = label
                self.link = link
            }
        }

        public let links: [Link]

        public init(links: [Link]) {
            self.links = links
        }
    }

    public let state: State

    public init(state: State) {
        self.state = state
    }

    public func content() -> some BasicTag {
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
