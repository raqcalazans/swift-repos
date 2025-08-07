import Foundation
import RxSwift
import RxCocoa

/// A protocol that defines the base structure for all ViewModels/Stores in the application.
/// It establishes a clear contract for the unidirectional data flow (TCA-like).
protocol ViewModelProtocol {
    /// The type that represents the View's state (e.g., `RepositoryListState`).
    associatedtype State
    
    /// The type that represents user actions or events from the View/Effects (e.g., `RepositoryListAction`).
    associatedtype Action
    
    /// The state output from the ViewModel. The View observes this Driver to update itself.
    var state: Driver<State> { get }
    
    /// The action input for the ViewModel. The View sends Actions to this Relay.
    var action: PublishRelay<Action> { get }
}
