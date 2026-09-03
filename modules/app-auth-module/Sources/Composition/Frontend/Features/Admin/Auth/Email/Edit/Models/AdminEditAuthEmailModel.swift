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

struct AdminEditAuthEmailModel: Sendable {
    let id: String
    let identityId: String
    let isPrimary: Bool

    var payload: AuthEmailFormPayloadModel {
        .init(identityId: identityId, isPrimary: isPrimary)
    }
}
