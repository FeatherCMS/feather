import UserApplication
import UserDomain
import UserModule

public enum ErrorAdapter {

    public static func adapt(_ error: any Error) -> (any Error)? {
        if let error = error as? Identity.Add.UseCase.Error {
            return IdentityAddErrorAdapter(error: error)
        }
        if let error = error as? Identity.Edit.UseCase.Error {
            return IdentityEditErrorAdapter(error: error)
        }
        if let error = error as? Role.Edit.UseCase.Error {
            return RoleEditErrorAdapter(error: error)
        }
        if let error = error as? Role.Model.Error {
            return RoleModelErrorAdapter(error: error)
        }
        return nil
    }
}
