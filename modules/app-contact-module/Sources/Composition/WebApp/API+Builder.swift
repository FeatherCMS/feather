public import ContactWebShared
public import FeatherWebShared

extension ContactAPIBuilder {
    public func makeContactApp(
        _ context: DefaultRequestContext
    ) -> ContactAppAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
    }
}
