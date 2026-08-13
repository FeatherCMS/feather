import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebStandards

struct AdminAddAuthMagicLinkModel: Sendable {
    let credentialId: String
    let isPersistent: Bool

    var payload: AuthMagicLinkFormPayloadModel {
        .init(credentialId: credentialId, isPersistent: isPersistent)
    }
}
