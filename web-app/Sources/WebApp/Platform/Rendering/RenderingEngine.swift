import CSS
import HTML
import Hummingbird
import SGML
import SVG
import WebStandards

protocol RenderingEngine: Sendable {
    func renderPage<T: FlowContent>(
        request: Request,
        title: String,
        description: String,
        imagePath: String,
        content: T
    ) -> HTMLResponse

    func renderPublicPage<T: FlowContent>(
        request: Request,
        title: String,
        description: String,
        imageURL: String,
        canonicalURL: String?,
        noIndex: Bool,
        cssCodeInjection: String?,
        javascriptCodeInjection: String?,
        structuredDataCodeInjection: String?,
        content: T
    ) -> HTMLResponse

    func renderAdminPage<T: Component>(
        request: Request,
        title: String,
        description: String,
        imagePath: String,
        sidebarState: AdminSidebar.State,
        content: T
    ) -> HTMLResponse

    func adminSidebarState(
        request: Request,
        permissions: Set<String>
    ) -> AdminSidebar.State
}

struct DefaultRenderingEngine: RenderingEngine {
    let publicOrigins: AppPublicOriginConfiguration
    private let assetVersion = "v=2"

    func renderPage<T: FlowContent>(
        request: Request,
        title: String,
        description: String,
        imagePath: String,
        content: T
    ) -> HTMLResponse {
        let body = Body {
            content
        }

        let collector = ComponentStylesheetCollector()
        let renderer = StylesheetRenderer(minify: false, indent: 4)
        let css = renderer.render(collector.getStylesheet(from: body))

        let head = Head {
            Metadata(
                canonicalUrl: normalizedURL(
                    base: publicOrigins.siteBaseURL,
                    path: request.uri.path
                ),
                title: title,
                description: description,
                imageUrl: normalizedURL(
                    base: publicOrigins.staticBaseURL,
                    path: imagePath
                ),
                noIndex: false
            )
            Link(rel: .stylesheet)
                .href(
                    normalizedURL(
                        base: publicOrigins.staticBaseURL,
                        path: "/base.css"
                    ) + "?\(assetVersion)"
                )
            Link(rel: .stylesheet)
                .href(
                    normalizedURL(
                        base: publicOrigins.staticBaseURL,
                        path: "/style.css"
                    ) + "?\(assetVersion)"
                )
            Link(rel: .stylesheet).href("/style.css?\(assetVersion)")
            Style(css)
        }

        let html = Html {
            head
            body
        }
        .lang("en-US")

        return .init(html)
    }

    func renderPublicPage<T: FlowContent>(
        request: Request,
        title: String,
        description: String,
        imageURL: String,
        canonicalURL: String?,
        noIndex: Bool,
        cssCodeInjection: String?,
        javascriptCodeInjection: String?,
        structuredDataCodeInjection: String?,
        content: T
    ) -> HTMLResponse {
        let body = Body {
            content
            if let javascriptCodeInjection, !javascriptCodeInjection.isEmpty {
                Script(javascriptCodeInjection)
            }
        }

        let collector = ComponentStylesheetCollector()
        let renderer = StylesheetRenderer(minify: false, indent: 4)
        let css = renderer.render(collector.getStylesheet(from: body))

        let head = Head {
            Metadata(
                canonicalUrl: normalizedCanonicalURL(
                    requestPath: request.uri.path,
                    override: canonicalURL
                ),
                title: title,
                description: description,
                imageUrl: normalizedPublicImageURL(imageURL),
                noIndex: noIndex
            )
            Link(rel: .stylesheet)
                .href(
                    normalizedURL(
                        base: publicOrigins.staticBaseURL,
                        path: "/base.css"
                    ) + "?\(assetVersion)"
                )
            Link(rel: .stylesheet)
                .href(
                    normalizedURL(
                        base: publicOrigins.staticBaseURL,
                        path: "/style.css"
                    ) + "?\(assetVersion)"
                )
            Link(rel: .stylesheet).href("/style.css?\(assetVersion)")
            Style(css)
            if let cssCodeInjection, !cssCodeInjection.isEmpty {
                Style(cssCodeInjection)
            }
            if let structuredDataCodeInjection,
                !structuredDataCodeInjection.isEmpty
            {
                Script(structuredDataCodeInjection)
                    .type("application/ld+json")
            }
        }

        let html = Html {
            head
            body
        }
        .lang("en-US")

        return .init(html)
    }

    func renderAdminPage<T: Component>(
        request: Request,
        title: String,
        description: String,
        imagePath: String,
        sidebarState: AdminSidebar.State,
        content: T
    ) -> HTMLResponse {
        let toast = AdminToastRedirect.payload(from: request)
        let body = Body {
            AdminBody(
                state: .init(
                    sidebar: sidebarState,
                    toast: toast,
                    content: content
                )
            )
        }

        let collector = ComponentStylesheetCollector()
        let renderer = StylesheetRenderer(minify: false, indent: 4)
        let css = renderer.render(collector.getStylesheet(from: body))

        let head = Head {
            Metadata(
                canonicalUrl: normalizedURL(
                    base: publicOrigins.siteBaseURL,
                    path: request.uri.path
                ),
                title: title,
                description: description,
                imageUrl: normalizedURL(
                    base: publicOrigins.staticBaseURL,
                    path: imagePath
                ),
                noIndex: false
            )
            Link(rel: .stylesheet)
                .href(
                    normalizedURL(
                        base: publicOrigins.staticBaseURL,
                        path: "/base.css"
                    ) + "?\(assetVersion)"
                )
            Link(rel: .stylesheet)
                .href(
                    normalizedURL(
                        base: publicOrigins.staticBaseURL,
                        path: "/style.css"
                    ) + "?\(assetVersion)"
                )
            Link(rel: .stylesheet)
                .href(
                    normalizedURL(
                        base: publicOrigins.staticBaseURL,
                        path: "/toast.css"
                    ) + "?\(assetVersion)"
                )
            Link(rel: .stylesheet).href("/style.css?\(assetVersion)")
            Style(css)
        }

        let html = Html {
            head
            body
        }
        .lang("en-US")

        return .init(html)
    }

    private func normalizedURL(
        base: String,
        path: String
    ) -> String {
        var url = base
        if !url.hasSuffix("/") { url += "/" }
        let normalizedPath =
            path.hasPrefix("/") ? String(path.dropFirst()) : path
        if normalizedPath.isEmpty { return url }
        url += normalizedPath
        if normalizedPath.contains(".") { return url }
        if !url.hasSuffix("/") { url += "/" }
        return url
    }

    private func normalizedCanonicalURL(
        requestPath: String,
        override: String?
    ) -> String {
        guard let override, !override.isEmpty else {
            return normalizedURL(
                base: publicOrigins.siteBaseURL,
                path: requestPath
            )
        }
        return override
    }

    private func normalizedPublicImageURL(
        _ imageURL: String
    ) -> String {
        guard !imageURL.isEmpty else {
            return normalizedURL(
                base: publicOrigins.staticBaseURL,
                path: "images/puppy.png"
            )
        }
        if imageURL.hasPrefix("http://") || imageURL.hasPrefix("https://") {
            return imageURL
        }
        return normalizedURL(
            base: publicOrigins.staticBaseURL,
            path: imageURL
        )
    }

    func adminSidebarState(
        request: Request,
        permissions: Set<String>
    ) -> AdminSidebar.State {
        let path = request.uri.path
        func isIn(
            _ prefix: String
        ) -> Bool {
            path == prefix || path.hasPrefix(prefix)
        }
        func isRoot() -> Bool {
            path == "/"
        }
        func item(
            icon: SVG,
            label: String,
            link: String,
            isCurrent: Bool,
            permission: String? = nil
        ) -> AdminSidebar.State.Group.Menu.Item? {
            if let permission, !permissions.contains(permission) {
                return nil
            }
            return .init(
                icon: icon,
                label: label,
                link: link,
                isCurrent: isCurrent
            )
        }

        func directMenu(
            icon: SVG,
            label: String,
            link: String,
            isCurrent: Bool,
            permission: String? = nil
        ) -> AdminSidebar.State.Group.Menu? {
            guard
                let item = item(
                    icon: icon,
                    label: label,
                    link: link,
                    isCurrent: isCurrent,
                    permission: permission
                )
            else {
                return nil
            }
            return .init(current: item, children: [])
        }

        func submenu(
            icon: SVG,
            label: String,
            isCurrent: Bool,
            children: [AdminSidebar.State.Group.Menu.Item?]
        ) -> AdminSidebar.State.Group.Menu? {
            let visibleChildren = children.compactMap { $0 }
            guard !visibleChildren.isEmpty else { return nil }
            return .init(
                current: .init(
                    icon: icon,
                    label: label,
                    link: nil,
                    isCurrent: isCurrent
                ),
                children: visibleChildren
            )
        }

        let siteMenus = [
            directMenu(
                icon: FeatherIcons.globe(),
                label: "Home",
                link: "/",
                isCurrent: isRoot()
            )
        ]
        .compactMap { $0 }

        let authMenus: [AdminSidebar.State.Group.Menu.Item?] = [
            item(
                icon: FeatherIcons.lock(),
                label: "Access Control",
                link: "/admin/auth/access-control/",
                isCurrent: isIn("/admin/auth/access-control/"),
                permission: AdminAuth.Scope.accessControl.list
            ),
            item(
                icon: FeatherIcons.link(),
                label: "Magic links",
                link: "/admin/auth/magic-links/",
                isCurrent: isIn("/admin/auth/magic-links/"),
                permission: AdminAuth.Scope.magicLinks.list
            ),
            item(
                icon: FeatherIcons.user(),
                label: "Profile",
                link: "/admin/auth/profile/",
                isCurrent: isIn("/admin/auth/profile/"),
                permission: AdminAuth.Scope.profile.read
            ),
            item(
                icon: FeatherIcons.settings(),
                label: "Settings",
                link: "/admin/auth/settings/",
                isCurrent: isIn("/admin/auth/settings/"),
                permission: AdminAuth.Scope.settings.read
            ),
        ]

        let userMenus: [AdminSidebar.State.Group.Menu.Item?] = [
            item(
                icon: FeatherIcons.userCheck(),
                label: "Accounts",
                link: "/admin/user/accounts/",
                isCurrent: isIn("/admin/user/accounts/"),
                permission: AdminUser.Scope.accounts.list
            ),
            item(
                icon: FeatherIcons.users(),
                label: "Roles",
                link: "/admin/user/roles/",
                isCurrent: isIn("/admin/user/roles/"),
                permission: AdminUser.Scope.roles.list
            ),
            item(
                icon: FeatherIcons.mail(),
                label: "Invitations",
                link: "/admin/user/invitations/",
                isCurrent: isIn("/admin/user/invitations/"),
                permission: AdminUser.Scope.invitations.list
            ),
        ]

        let systemMenus = [
            item(
                icon: FeatherIcons.sliders(),
                label: "Variables",
                link: "/admin/system/variables/",
                isCurrent: isIn("/admin/system/variables/"),
                permission: AdminSystem.Scope.variables.list
            ),
            item(
                icon: FeatherIcons.lock(),
                label: "Permissions",
                link: "/admin/system/permissions/",
                isCurrent: isIn("/admin/system/permissions/"),
                permission: AdminSystem.Scope.permissions.list
            ),
        ]

        let mediaMenus: [AdminSidebar.State.Group.Menu.Item?] = [
            item(
                icon: FeatherIcons.box(),
                label: "Assets",
                link: "/admin/media/assets/",
                isCurrent: isIn("/admin/media/assets/"),
                permission: AdminMedia.Scope.assets.list
            ),
            item(
                icon: FeatherIcons.playCircle(),
                label: "Processors",
                link: "/admin/media/processors/",
                isCurrent: isIn("/admin/media/processors/"),
                permission: AdminMedia.Scope.processors.list
            ),
        ]

        let redirectMenus = [
            item(
                icon: FeatherIcons.cornerUpRight(),
                label: "Rules",
                link: "/admin/redirect/rules/",
                isCurrent: isIn("/admin/redirect/rules/"),
                permission: AdminRedirect.Scope.rules.list
            ),
            item(
                icon: FeatherIcons.alertCircle(),
                label: "404s",
                link: "/admin/redirect/404s/",
                isCurrent: isIn("/admin/redirect/404s/"),
                permission: AdminRedirect.Scope.notFound.list
            ),
        ]

        let blogMenus = [
            item(
                icon: FeatherIcons.fileText(),
                label: "Posts",
                link: "/admin/blog/posts/",
                isCurrent: isIn("/admin/blog/posts/"),
                permission: AdminBlog.Scope.posts.list
            ),
            item(
                icon: FeatherIcons.users(),
                label: "Authors",
                link: "/admin/blog/authors/",
                isCurrent: isIn("/admin/blog/authors/"),
                permission: AdminBlog.Scope.authors.list
            ),
            item(
                icon: FeatherIcons.tag(),
                label: "Tags",
                link: "/admin/blog/tags/",
                isCurrent: isIn("/admin/blog/tags/"),
                permission: AdminBlog.Scope.tags.list
            ),
            item(
                icon: FeatherIcons.settings(),
                label: "Settings",
                link: "/admin/blog/settings/",
                isCurrent: isIn("/admin/blog/settings/"),
                permission: AdminBlog.Scope.settings.read
            ),
        ]

        let webMenus = [
            item(
                icon: FeatherIcons.fileText(),
                label: "Pages",
                link: "/admin/web/pages/",
                isCurrent: isIn("/admin/web/pages/"),
                permission: AdminWeb.Scope.pages.list
            ),
            item(
                icon: FeatherIcons.menu(),
                label: "Menus",
                link: "/admin/web/menus/",
                isCurrent: isIn("/admin/web/menus/"),
                permission: AdminWeb.Scope.menus.list
            ),
            item(
                icon: FeatherIcons.bookOpen(),
                label: "Metadata",
                link: "/admin/web/metadata/",
                isCurrent: isIn("/admin/web/metadata/"),
                permission: AdminWeb.Scope.metadata.list
            ),
            item(
                icon: FeatherIcons.settings(),
                label: "Settings",
                link: "/admin/web/settings/",
                isCurrent: isIn("/admin/web/settings/"),
                permission: AdminWeb.Scope.settings.read
            ),
        ]

        let analyticsMenus = [
            item(
                icon: FeatherIcons.monitor(),
                label: "Web",
                link: "/admin/analytics/web/",
                isCurrent: isIn("/admin/analytics/web/"),
                permission: AdminAnalytics.Scope.insights.list
            ),
            item(
                icon: FeatherIcons.server(),
                label: "API",
                link: "/admin/analytics/api/",
                isCurrent: isIn("/admin/analytics/api/"),
                permission: AdminAnalytics.Scope.insights.list
            ),
            item(
                icon: FeatherIcons.activity(),
                label: "Logs",
                link: "/admin/analytics/logs/",
                isCurrent: isIn("/admin/analytics/logs/"),
                permission: AdminAnalytics.Scope.logs.list
            ),
        ]

        let adminMenus = [
            directMenu(
                icon: FeatherIcons.home(),
                label: "Dashboard",
                link: "/admin/",
                isCurrent: path == "/admin/"
            ),
            submenu(
                icon: FeatherIcons.barChart2(),
                label: "Analytics",
                isCurrent: isIn("/admin/analytics/"),
                children: analyticsMenus
            ),
            submenu(
                icon: FeatherIcons.image(),
                label: "Media",
                isCurrent: isIn("/admin/media/"),
                children: mediaMenus
            ),
            submenu(
                icon: FeatherIcons.layout(),
                label: "Web",
                isCurrent: isIn("/admin/web/"),
                children: webMenus
            ),
            submenu(
                icon: FeatherIcons.edit3(),
                label: "Blog",
                isCurrent: isIn("/admin/blog/"),
                children: blogMenus
            ),
            submenu(
                icon: FeatherIcons.gitBranch(),
                label: "Redirect",
                isCurrent: isIn("/admin/redirect/"),
                children: redirectMenus
            ),
            submenu(
                icon: FeatherIcons.lock(),
                label: "Auth",
                isCurrent: isIn("/admin/auth/"),
                children: authMenus
            ),
            submenu(
                icon: FeatherIcons.user(),
                label: "User",
                isCurrent: isIn("/admin/user/"),
                children: userMenus
            ),
            submenu(
                icon: FeatherIcons.settings(),
                label: "System",
                isCurrent: isIn("/admin/system/"),
                children: systemMenus
            ),
        ]
        .compactMap { $0 }

        return .init(
            current: path,
            groups: [
                .init(
                    label: "Site",
                    menus: siteMenus
                ),
                .init(
                    label: "Admin",
                    menus: adminMenus
                ),
            ]
            .filter { !$0.menus.isEmpty }
        )
    }
}
