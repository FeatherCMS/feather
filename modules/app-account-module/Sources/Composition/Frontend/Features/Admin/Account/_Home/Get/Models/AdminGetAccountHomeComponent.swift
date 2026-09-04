import FeatherAdmin
import HTML
import SGML
import WebComponents
import WebBuilders

struct AdminGetAccountHomeComponent: Leaf {
    func renderHTML() -> some BasicTag {
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
