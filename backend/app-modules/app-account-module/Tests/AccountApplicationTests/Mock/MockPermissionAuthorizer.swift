import Application

actor MockPermissionAuthorizer: Authorizer {
    private(set) var canCallCount = 0
    private let permissions: Set<PermissionKey>

    init(permissions: Set<PermissionKey>) {
        self.permissions = permissions
    }

    init(permissions: [PermissionKey]) {
        self.init(permissions: Set(permissions))
    }

    func can(
        subject: Subject,
        perform action: any Action
    ) async throws -> Bool {
        canCallCount += 1
        return try await action.authorize(
            subject: subject,
            permissions: permissions
        )
    }
}
