import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct AppBlogTagListPage: Component {
    let state: AppGetBlogTagListModel

    func html(context: inout RenderContext) -> some BasicTag {
        Main {
            context.render(AppPublicStyleAnchor())
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
