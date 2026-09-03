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

struct AdminAddAuthEmailModel: Sendable {
    let identityId: String
    let email: String
    let isPrimary: Bool
    let isVerified: Bool

    init(
        identityId: String,
        email: String = "",
        isPrimary: Bool,
        isVerified: Bool = false
    ) {
        self.identityId = identityId
        self.email = email
        self.isPrimary = isPrimary
        self.isVerified = isVerified
    }

    var payload: AuthEmailFormPayloadModel {
        .init(
            identityId: identityId,
            email: email,
            isPrimary: isPrimary,
            isVerified: isVerified
        )
    }
}
