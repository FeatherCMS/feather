import BlogAppAPI
import BlogModule
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebApp

extension Post.List {
    struct Page: Component {
        let state: Post.List.Model

        func html(context: inout BuilderContext) -> some BasicTag {
            Main {
                context.build(PublicContent.StyleAnchor())
                Div {
                    Div {
                        P("Blog").class("public-eyebrow")
                        H1(state.title)
                        P("Published posts")
                    }
                    .class("public-heading")

                    Div {
                        for item in state.items {
                            A {
                                H2(item.title)
                                if let publishedAt = item.publishedAt {
                                    Div {
                                        Span(publishedAt)
                                    }
                                    .class("public-meta")
                                }
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
}
