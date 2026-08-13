import AuthDomain
import FeatherApplication
import FeatherContracts

public struct WriteCredentialLink: Scope {
    public let credential: any CredentialRepository

    public init(credential: any CredentialRepository) {
        self.credential = credential
    }
}
