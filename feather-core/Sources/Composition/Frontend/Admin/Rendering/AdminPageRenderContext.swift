public import Hummingbird

public struct AdminPageRenderContext: Sendable {
    public let menuGroups: [NewAdminSideBar.Group]
    public let accountTopBarState: NewAdminTopBar.State

    public init(
        menuGroups: [NewAdminSideBar.Group],
        accountTopBarState: NewAdminTopBar.State = .init()
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
