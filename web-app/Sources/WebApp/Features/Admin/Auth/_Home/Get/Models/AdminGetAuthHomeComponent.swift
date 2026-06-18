import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminGetAuthHomeComponent: Component {
    func content() -> some BasicTag {
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
                Li { A("Settings").href("/admin/auth/settings/") }
                Li { A("Access control").href("/admin/auth/access-control/") }
            }
        }
        .class("cms-section")
    }
}
