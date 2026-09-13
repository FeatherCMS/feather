import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct AdminGetAccountOverviewComponent: Component {
    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            Nav {
                Ol {
                    Li { A("Admin").href("/admin/") }
                    Li("Account").ariaCurrent(.page)
                }
            }
            .class("cms-breadcrumb")
            .ariaLabel("Breadcrumb")

            H1("Account module")
            Ul {
                Li { A("Profile").href("/admin/account/profile/") }
                Li { A("Invitations").href("/admin/account/invitations/") }
            }
        }
        .class("cms-section")
    }
}
