import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

public struct AdminBreadcrumb: Component {

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

    public func html(context: inout RenderContext) -> Nav {
        Nav {
            if !state.links.isEmpty {
                Ol {
                    for breadcrumb in state.links {
                        Li { A(breadcrumb.label).href(breadcrumb.link) }
                    }
                }
            }
        }
        .class("cms-breadcrumb")
        .ariaLabel("Breadcrumb")
    }
}
