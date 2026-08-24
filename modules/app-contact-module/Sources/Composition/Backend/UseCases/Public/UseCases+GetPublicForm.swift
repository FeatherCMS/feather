import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import Foundation

extension UseCases {

    public func makeGetPublicForm() -> GetPublicForm {
        .init(transaction: formTransaction())
    }
}
