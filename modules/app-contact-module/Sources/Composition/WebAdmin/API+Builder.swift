public import ContactWebShared
public import FeatherWebAdmin

extension ContactAPIBuilder {
    public func makeContactAdmin(
        _ context: AuthenticatedRequestContext
    ) -> ContactAdminAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
    }
}
