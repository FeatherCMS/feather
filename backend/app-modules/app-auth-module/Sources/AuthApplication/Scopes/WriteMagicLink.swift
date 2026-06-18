import AuthDomain
import Application

public struct WriteMagicLink: Scope {
    public let magicLink: any MagicLinkRepository

    public init(magicLink: any MagicLinkRepository) {
        self.magicLink = magicLink
    }
}
