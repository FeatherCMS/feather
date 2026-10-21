import AuthDomain
public import AuthModule
public import FeatherApplication
import FeatherMail
import FeatherModuleKit
import Foundation
import SystemApplication

extension MagicLink.Request {
    public struct Input: DTO {
        public let email: String
        public let isPersistent: Bool

        public init(
            email: String,
            isPersistent: Bool
        ) {
            self.email = email
            self.isPersistent = isPersistent
        }
    }
}
