import HTML
import SGML
import WebStandards

struct AppBlogAuthorListPage: Component, FlowContent {
    let state: AppGetBlogAuthorListModel

    func content() -> some BasicTag {
        Main {
            AppPublicStyleAnchor()
            Div {
                Div {
                    P("Blog").class("public-eyebrow")
                    H1(state.title)
                    P("Published authors")
                }
                .class("public-heading")

                Div {
                    for item in state.items {
                        A {
                            H2(item.name)
                            if !item.excerpt.isEmpty {
                                P(item.excerpt)
                            }
                        }
                        .href(item.href)
                        .class("public-card")
                    }
                }
                .class("public-grid")
            }
            .class("public-container public-panel")
        }
        .class("public-shell")
    }
}
