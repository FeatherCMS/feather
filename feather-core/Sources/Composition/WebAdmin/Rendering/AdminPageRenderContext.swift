public import Hummingbird

public struct AdminPageRenderContext: Sendable {
    public let menuGroups: [AdminSideBar.Group]
    public let accountTopBarState: AdminTopBar.State

    public init(
        menuGroups: [AdminSideBar.Group],
        accountTopBarState: AdminTopBar.State = .init()
    ) {
        self.menuGroups = menuGroups
        self.accountTopBarState = accountTopBarState
    }
}

public protocol AdminPageRenderContextProvider: Sendable {
    func make(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> AdminPageRenderContext
}
