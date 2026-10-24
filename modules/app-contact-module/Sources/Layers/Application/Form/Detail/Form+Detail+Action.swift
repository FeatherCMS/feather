import ContactModule
import FeatherModuleKit

extension Form.Detail {
    struct Action: PermissionAction {
        let key = Form.Permissions.read
    }

    struct MailListAction: PermissionAction {
        let key = SubmissionMail.Permissions.list
    }
}
