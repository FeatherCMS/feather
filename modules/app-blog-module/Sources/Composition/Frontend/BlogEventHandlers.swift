import FeatherContracts
import WebApplication
import WebDomain

public enum BlogEventHandlers {
    public static func register(in registry: inout EventRegistry) {
        registry.register(
            event: WebMenuItemProvider.self,
            context: WebEventContext.self
        ) { event, _ in
            guard event.menuKey == "main" else { return [] }
            return [
                .init(label: "Posts", url: "/posts/", priority: 10),
                .init(label: "Authors", url: "/authors/", priority: 20),
                .init(label: "Tags", url: "/tags/", priority: 30),
            ]
        }

        registry.register(
            event: WebMetadataReferenceTypeOptionProvider.self,
            context: WebEventContext.self
        ) { _, _ in
            [
                .init(value: "blog.post", title: "Blog post"),
                .init(value: "blog.author", title: "Blog author"),
                .init(value: "blog.tag", title: "Blog tag"),
            ]
        }

        registry.register(
            event: WebPageTemplateOptionProvider.self,
            context: WebEventContext.self
        ) { _, _ in
            [
                .init(value: "blog.post", title: "Blog post"),
                .init(value: "blog.author", title: "Blog author"),
                .init(value: "blog.tag", title: "Blog tag"),
                .init(value: "blog.posts", title: "Blog posts"),
                .init(value: "blog.authors", title: "Blog authors"),
                .init(value: "blog.tags", title: "Blog tags"),
            ]
        }

        registry.register(
            event: WebPageProvider.self,
            context: WebEventContext.self
        ) { _, _ in
            [
                .init(
                    title: "Posts",
                    excerpt: "Published blog posts.",
                    content: "Published blog posts.",
                    metadata: .init(
                        template: "blog.posts",
                        slug: "posts",
                        status: .published
                    )
                ),
                .init(
                    title: "Authors",
                    excerpt: "Published authors.",
                    content: "Published authors.",
                    metadata: .init(
                        template: "blog.authors",
                        slug: "authors",
                        status: .published
                    )
                ),
                .init(
                    title: "Tags",
                    excerpt: "Published tags.",
                    content: "Published tags.",
                    metadata: .init(
                        template: "blog.tags",
                        slug: "tags",
                        status: .published
                    )
                ),
            ]
        }
    }
}
