import BlogApplication
import BlogContracts
import FeatherContracts
import FeatherInfrastructure
import Foundation
import SystemApplication
import SystemContracts
import WebApplication
import WebContracts
import WebDomain

public enum EventHandlers {

    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: PermissionSeedProvider.self,
            context: EventContext.self
        ) { _, _ in
            BlogPermissions.allPermissions()
                .map {
                    .init(permission: $0)
                }
        }

        registry.register(
            event: VariableSeedProvider.self,
            context: EventContext.self
        ) { _, _ in
            [
                .init(
                    id: "blog-settings-post-list-path",
                    value: "posts",
                    name: "blog.post.list_path",
                    notes: "Public blog post list path."
                ),
                .init(
                    id: "blog-settings-author-list-path",
                    value: "authors",
                    name: "blog.author.list_path",
                    notes: "Public blog author list path."
                ),
                .init(
                    id: "blog-settings-tag-list-path",
                    value: "tags",
                    name: "blog.tag.list_path",
                    notes: "Public blog tag list path."
                ),
                .init(
                    id: "blog-settings-post-path-prefix",
                    value: "posts",
                    name: "blog.post.path_prefix",
                    notes: "Public blog post detail path prefix."
                ),
                .init(
                    id: "blog-settings-author-path-prefix",
                    value: "authors",
                    name: "blog.author.path_prefix",
                    notes: "Public blog author detail path prefix."
                ),
                .init(
                    id: "blog-settings-tag-path-prefix",
                    value: "tags",
                    name: "blog.tag.path_prefix",
                    notes: "Public blog tag detail path prefix."
                ),
            ]
        }

        registry.register(
            event: WebMenuItemProvider.self,
            context: WebEventContext.self
        ) { event, _ in
            guard event.menuKey == "main" else { return [] }
            return [
                .init(
                    label: "Posts",
                    url: "/posts/",
                    priority: 10
                ),
                .init(
                    label: "Authors",
                    url: "/authors/",
                    priority: 20
                ),
                .init(
                    label: "Tags",
                    url: "/tags/",
                    priority: 30
                ),
            ]
        }

        registry.register(
            event: WebMetadataReferenceTypeOptionProvider.self,
            context: WebEventContext.self
        ) { _, _ in
            [
                .init(
                    value: "blog.post",
                    title: "Blog post"
                ),
                .init(
                    value: "blog.author",
                    title: "Blog author"
                ),
                .init(
                    value: "blog.tag",
                    title: "Blog tag"
                ),
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
