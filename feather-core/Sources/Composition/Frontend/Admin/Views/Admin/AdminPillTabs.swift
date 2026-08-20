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
                }
                .admin-pill-tabs a {
                    flex: 1;
                    border: 0;
                    border-radius: 999px;
                    background: transparent;
                    color: var(--cms-light-font);
                    padding: 8px 12px;
                    line-height: 1.2;
                    text-align: center;
                    cursor: pointer;
                    text-decoration: none;
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
            if links.contains(where: {
                $0.href.hasPrefix("#admin-content-editor-")
            }) {
                Script(
                    """
                    (function () {
                        document.querySelectorAll('.admin-pill-tabs a[href^="#admin-content-editor-"]').forEach(function (link) {
                            if (link.__contentEditorTabBound) return;
                            link.__contentEditorTabBound = true;
                            link.addEventListener('click', function (event) {
                                event.preventDefault();
                                var form = link.closest('form');
                                if (!form) return;
                                var id = link.getAttribute('href').substring(1);
                                form.querySelectorAll('.admin-content-editor-panel').forEach(function (panel) {
                                    panel.hidden = panel.id !== id;
                                });
                                link.closest('.admin-pill-tabs').querySelectorAll('a').forEach(function (tab) {
                                    tab.classList.toggle('is-current', tab === link);
                                });
                            });
                        });
                    })();
                    """
                )
            }
        }
        .class("admin-media-asset-picker-tabs", "admin-pill-tabs")
    }
}
