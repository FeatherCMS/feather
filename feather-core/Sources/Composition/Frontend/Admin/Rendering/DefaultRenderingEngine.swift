import CSS
import HTML
import Hummingbird
import SGML
import SVG
import WebComponents
import WebBuilders

public struct RenderingEngineAssetConfiguration: Sendable {
    public let publicStylesheetPaths: [String]
    public let adminStylesheetPaths: [String]
    public let rootStylesheetPath: String?

    public init(
        publicStylesheetPaths: [String] = [
            "/admin/base.css",
            "/admin/style.css",
            "/admin/toast.css",
        ],
        adminStylesheetPaths: [String] = [
            "/admin/base.css",
            "/admin/style.css",
            "/admin/toast.css",
        ],
        rootStylesheetPath: String? = nil
    ) {
        self.publicStylesheetPaths = publicStylesheetPaths
        self.adminStylesheetPaths = adminStylesheetPaths
        self.rootStylesheetPath = rootStylesheetPath
    }
}

public struct DefaultRenderingEngine: RenderingEngine {
    public let publicOrigins: AppPublicOriginConfiguration
    public let adminMenuCatalog: AdminMenuCatalog
    public let assets: RenderingEngineAssetConfiguration

    public init(
        publicOrigins: AppPublicOriginConfiguration,
        adminMenuCatalog: AdminMenuCatalog,
        assets: RenderingEngineAssetConfiguration = .init()
    ) {
        self.publicOrigins = publicOrigins
        self.adminMenuCatalog = adminMenuCatalog
        self.assets = assets
    }

    public func renderPage<T: FlowContent>(
        request: Request,
        title: String,
        description: String,
        imagePath: String,
        content: T
    ) -> HTMLResponse {
        let body = Body {
            content
        }

        let metadata = Metadata(
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
            ).renderHTML()
        var headElements = metadata.children + assets.publicStylesheetPaths.map {
            Link(rel: .stylesheet).href(stylesheetURL(path: $0))
        }
        if let path = assets.rootStylesheetPath {
            headElements.append(Link(rel: .stylesheet).href(path))
        }
        let head = Head(elements: headElements.compactMap { $0 as? any MetadataContent })

        let html = Html {
            head
            body
        }
        .lang("en-US")

        return .init(html)
    }

    public func renderAdminPage<T: Leaf>(
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
            ).renderHTML()
        }

        let metadata = Metadata(
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
            ).renderHTML()
        var headElements = metadata.children + assets.adminStylesheetPaths.map {
            Link(rel: .stylesheet).href(stylesheetURL(path: $0))
        }
        if let path = assets.rootStylesheetPath {
            headElements.append(Link(rel: .stylesheet).href(path))
        }
        let head = Head(elements: headElements.compactMap { $0 as? any MetadataContent })

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

    private func stylesheetURL(path: String) -> String {
        normalizedURL(base: publicOrigins.staticBaseURL, path: path)
    }

    public func adminSidebarState(
        request: Request,
        permissions: Set<String>
    ) -> AdminSidebar.State {
        let menuDefinitions = adminMenuCatalog.menus
            .filter { definition in
                guard let permission = definition.permission else {
                    return true
                }
                return permissions.contains(permission)
            }
            .sorted { $0.priority < $1.priority }
        var groups: [String: [AdminSidebar.State.Group.Menu]] = [:]
        for definition in menuDefinitions {
            let items = adminMenuCatalog.items
                .filter { $0.menuKey == definition.key }
                .filter { item in
                    guard let permission = item.permission else { return true }
                    return permissions.contains(permission)
                }
                .sorted { $0.priority < $1.priority }
                .map { item in
                    AdminSidebar.State.Group.Menu.Item(
                        icon: icon(named: item.icon),
                        label: item.label,
                        link: item.link,
                        isCurrent: isCurrent(item.link, path: request.uri.path)
                    )
                }
            guard definition.link != nil || !items.isEmpty else { continue }
            let current = AdminSidebar.State.Group.Menu.Item(
                icon: icon(named: definition.icon),
                label: definition.label,
                link: definition.link,
                isCurrent: definition.link.map {
                    isCurrent($0, path: request.uri.path)
                }
                    ?? items.contains(where: { $0.isCurrent })
            )
            groups[definition.groupKey, default: []]
                .append(
                    .init(current: current, children: items)
                )
        }
        return .init(
            current: request.uri.path,
            groups: ["site", "admin"]
                .compactMap { key in
                    guard let menus = groups[key], !menus.isEmpty else {
                        return nil
                    }
                    return .init(
                        label: key == "site" ? "Site" : "Admin",
                        menus: menus
                    )
                }
        )
    }
    private func isCurrent(_ link: String, path: String) -> Bool {
        guard link != "/" else { return path == "/" }
        guard path == link || path.hasPrefix(link) else { return false }

        // The admin root is a standalone route. It must not remain selected
        // while navigating to any other admin page.
        if link == "/admin/" {
            return path == link
        }
        return true
    }

    private func icon(named name: String) -> SVG {
        switch name {
        case "activity": return FeatherIcons.activity()
        case "alertCircle": return FeatherIcons.alertCircle()
        case "award": return FeatherIcons.award()
        case "barChart2": return FeatherIcons.barChart2()
        case "bookOpen": return FeatherIcons.bookOpen()
        case "box": return FeatherIcons.box()
        case "briefcase": return FeatherIcons.briefcase()
        case "clipboard": return FeatherIcons.clipboard()
        case "cornerUpRight": return FeatherIcons.cornerUpRight()
        case "edit3": return FeatherIcons.edit3()
        case "fileText": return FeatherIcons.fileText()
        case "gitBranch": return FeatherIcons.gitBranch()
        case "globe": return FeatherIcons.globe()
        case "grid": return FeatherIcons.grid()
        case "home": return FeatherIcons.home()
        case "image": return FeatherIcons.image()
        case "inbox": return FeatherIcons.inbox()
        case "key": return FeatherIcons.key()
        case "layout": return FeatherIcons.layout()
        case "link": return FeatherIcons.link()
        case "list": return FeatherIcons.list()
        case "lock": return FeatherIcons.lock()
        case "mail": return FeatherIcons.mail()
        case "menu": return FeatherIcons.menu()
        case "messageSquare": return FeatherIcons.messageSquare()
        case "monitor": return FeatherIcons.monitor()
        case "playCircle": return FeatherIcons.playCircle()
        case "send": return FeatherIcons.send()
        case "server": return FeatherIcons.server()
        case "settings": return FeatherIcons.settings()
        case "shield": return FeatherIcons.shield()
        case "sliders": return FeatherIcons.sliders()
        case "tag": return FeatherIcons.tag()
        case "tool": return FeatherIcons.tool()
        case "user": return FeatherIcons.user()
        case "userCheck": return FeatherIcons.userCheck()
        case "users": return FeatherIcons.users()
        default: return FeatherIcons.activity()
        }
    }
}
