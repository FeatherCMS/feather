import AuthDomain
import Application

public struct WriteSession: Scope {
    public let session: any SessionRepository

    public init(session: any SessionRepository) {
        self.session = session
    }
}
