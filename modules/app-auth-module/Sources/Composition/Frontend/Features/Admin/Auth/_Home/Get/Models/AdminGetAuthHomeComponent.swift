import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebComponents
import WebBuilders

struct AdminGetAuthHomeComponent: Leaf {
    func renderHTML() -> some BasicTag {
        Section {
            Nav {
                Ol {
                    Li { A("Admin").href("/admin/") }
                    Li("Auth").ariaCurrent(.page)
                }
            }
            .class("cms-breadcrumb")
            .ariaLabel("Breadcrumb")

            H1("Auth module")
            Ul {
                Li { A("Magic links").href("/admin/auth/magic-links/") }
                Li { A("Profile").href("/admin/auth/profile/") }
                Li { A("Settings").href("/admin/identity/settings/") }
                Li { A("Access control").href("/admin/auth/access-control/") }
            }
        }
        .class("cms-section")
    }
}
