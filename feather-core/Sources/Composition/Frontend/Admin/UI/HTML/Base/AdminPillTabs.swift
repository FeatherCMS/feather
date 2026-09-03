import HTML
import SGML
import WebStandards

public struct AdminPillTabs: Component, FlowContent {
    public struct Link: Sendable {
        public let label: String
        public let href: String
        public let isCurrent: Bool

        public init(label: String, href: String, isCurrent: Bool) {
            self.label = label
            self.href = href
            self.isCurrent = isCurrent
        }
    }

    public let links: [Link]

    public init(links: [Link]) {
        self.links = links
    }

    public func content() -> some BasicTag {
        Div {
            Style(
                """
                .admin-pill-tabs {
                    display: flex;
                    align-items: center;
                    border: 1px solid var(--cms-gray-3);
                    border-radius: 999px;
                    margin-bottom: 16px;
                    padding: 4px;
                    gap: 4px;
                    width: 100%;
                    overflow-x: auto;
                    overflow-y: hidden;
                    scrollbar-width: none;
                    -ms-overflow-style: none;
                    -webkit-overflow-scrolling: touch;
                }
                .admin-pill-tabs::-webkit-scrollbar {
                    display: none;
                }
                .admin-pill-tabs a {
                    flex: 1 0 auto;
                    border: 0;
                    border-radius: 999px;
                    background: transparent;
                    color: var(--cms-light-font);
                    padding: 8px 12px;
                    line-height: 1.2;
                    text-align: center;
                    cursor: pointer;
                    text-decoration: none;
                    white-space: nowrap;
                }
                .admin-pill-tabs a:hover:not(.is-current) {
                    color: var(--cms-link-hover);
                    text-decoration: underline;
                }
                .admin-pill-tabs a.is-current {
                    background: var(--cms-gray-4);
                    color: var(--cms-strong-font);
                }
                """
            )
            for link in links {
                A(link.label)
                    .href(link.href)
                    .if(link.isCurrent) { $0.class("is-current") }
            }
        }
        .class("admin-pill-tabs")
    }
}
