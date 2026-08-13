struct AppPublicResolvedContent: Sendable {
    let moduleContext: AppPublicResolvedModuleContext
    let isNotFound: Bool

    init(
        moduleContext: AppPublicResolvedModuleContext,
        isNotFound: Bool = false
    ) {
        self.moduleContext = moduleContext
        self.isNotFound = isNotFound
    }
}
