import HTML
import SGML
import WebStandards

struct AppBlogAuthorPage: Component, FlowContent {
    let state: AppGetBlogAuthorModel

    func content() -> some BasicTag {
        Main {
            AppPublicStyleAnchor()
            Div {
                Article {
                    Div {
                        P("Author").class("public-eyebrow")
                        H1(state.title)
                        if !state.subtitle.isEmpty {
                            P(state.subtitle)
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

                    if !state.links.isEmpty {
                        Section {
                            H2("Links")
                            Div {
                                for link in state.links {
                                    if link.isBlank {
                                        A(link.label)
                                            .href(link.url)
                                            .target(.blank)
                                    }
                                    else {
                                        A(link.label)
                                            .href(link.url)
                                    }
                                }
                            }
                            .class("public-links")
                        }
                        .class("public-section")
                    }

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
