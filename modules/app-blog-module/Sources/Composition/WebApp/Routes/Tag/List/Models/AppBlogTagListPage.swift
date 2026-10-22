import BlogAppAPI
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebApp

struct AppBlogTagListPage: Component {
    let state: AppGetBlogTagListModel

    func html(context: inout BuilderContext) -> some BasicTag {
        Main {
            context.build(AppPublicStyleAnchor())
            Div {
                Div {
                    P("Blog").class("public-eyebrow")
                    H1(state.title)
                    P("Published tags")
                }
                .class("public-heading")

                Div {
                    for item in state.items {
                        A {
                            H2(item.title)
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
