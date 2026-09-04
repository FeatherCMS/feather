import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebComponents
import WebBuilders

struct AppBlogTagPage: Leaf {
    let state: AppGetBlogTagModel

    func renderHTML() -> some BasicTag {
        Main {
            AppPublicStyleAnchor()
            Div {
                Article {
                    Div {
                        P("Tag").class("public-eyebrow")
                        H1(state.title)
                        if !state.excerpt.isEmpty {
                            P(state.excerpt)
                        }
                    }
                    .class("public-heading")

                    if let imageURL = state.imageURL {
                        Div {
                            Img(src: imageURL, alt: state.title)
                        }
                        .class("public-image")
                    }

                    AppPublicTextBlock(text: state.content)

                    if !state.posts.isEmpty {
                        Section {
                            H2("Posts")
                            Div {
                                for post in state.posts {
                                    A {
                                        H3(post.title)
                                        if !post.excerpt.isEmpty {
                                            P(post.excerpt)
                                        }
                                    }
                                    .href(post.href)
                                    .class("public-card")
                                }
                            }
                            .class("public-grid")
                        }
                        .class("public-section")
                    }
                }
                .class("public-panel")
            }
            .class("public-container")
        }
        .class("public-shell")
    }
}
