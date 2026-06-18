import AdminOpenAPI

extension Client {

    private func defaultPage() -> Components.Schemas.SearchPageSchema {
        .init(size: 20, number: 1)
    }

    func userAccountSearch(
        headers: Operations.UserAccountSearch.Input.Headers = .init()
    ) async throws -> Operations.UserAccountSearch.Output {
        try await userAccountSearch(
            headers: headers,
            body: .json(
                .init(
                    page: defaultPage(),
                    filters: .init(search: nil)
                )
            )
        )
    }

    func userRoleSearch(
        headers: Operations.UserRoleSearch.Input.Headers = .init()
    ) async throws -> Operations.UserRoleSearch.Output {
        try await userRoleSearch(
            headers: headers,
            body: .json(
                .init(
                    page: defaultPage(),
                    filters: .init(search: nil)
                )
            )
        )
    }

    func userInvitationSearch(
        headers: Operations.UserInvitationSearch.Input.Headers = .init()
    ) async throws -> Operations.UserInvitationSearch.Output {
        try await userInvitationSearch(
            headers: headers,
            body: .json(
                .init(
                    page: defaultPage(),
                    filters: .init(search: nil)
                )
            )
        )
    }

    func userMagicLinkSearch(
        headers: Operations.UserMagicLinkSearch.Input.Headers = .init()
    ) async throws -> Operations.UserMagicLinkSearch.Output {
        try await userMagicLinkSearch(
            headers: headers,
            body: .json(
                .init(
                    page: defaultPage(),
                    filters: .init(search: nil)
                )
            )
        )
    }

    func systemPermissionSearch(
        headers: Operations.SystemPermissionSearch.Input.Headers = .init()
    ) async throws -> Operations.SystemPermissionSearch.Output {
        try await systemPermissionSearch(
            headers: headers,
            body: .json(
                .init(
                    page: defaultPage(),
                    filters: .init(search: nil)
                )
            )
        )
    }

    func systemVariableSearch(
        headers: Operations.SystemVariableSearch.Input.Headers = .init()
    ) async throws -> Operations.SystemVariableSearch.Output {
        try await systemVariableSearch(
            headers: headers,
            body: .json(
                .init(
                    page: defaultPage(),
                    filters: .init(search: nil)
                )
            )
        )
    }
}
