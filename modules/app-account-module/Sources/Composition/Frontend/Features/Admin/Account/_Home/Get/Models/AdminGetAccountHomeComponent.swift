import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct AdminGetAccountHomeComponent: Component {
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
                Li { A("Settings").href("/admin/account/settings/") }
            }
        }
        .class("cms-section")
    }
}
