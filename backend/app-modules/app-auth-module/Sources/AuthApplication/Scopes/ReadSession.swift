import AuthDomain
import Application

public struct ReadSession: Scope {
    public let session: any SessionQueries

    public init(
        session: any SessionQueries
    ) {
        self.session = session
    }
}
