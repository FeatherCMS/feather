import ContactModule
import FeatherModuleKit

extension Form.Add {
    struct Action: PermissionAction {
        let key = Form.Permissions.create
    }

    struct MailCreateAction: PermissionAction {
        let key = SubmissionMail.Permissions.create
    }

    struct MailListAction: PermissionAction {
        let key = SubmissionMail.Permissions.list
    }
}
