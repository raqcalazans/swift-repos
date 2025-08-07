import Foundation
@preconcurrency import RxSwift
import RxCocoa

// MARK: - TaskResult

/// A type alias for the result of an asynchronous `Task`, used within Effects.
typealias TaskResult<Success> = Result<Success, Error>

// MARK: - Effect

/// A struct that represents an asynchronous side effect that produces an Action.
struct Effect<Action> {
    let upstream: Observable<Action>

    /// Creates an Effect that executes an asynchronous operation.
    /// - Parameter operation: An async closure that can send actions back to the Store.
    /// - Returns: A new Effect.
    static func run(
        operation: @escaping @Sendable (Send) async -> Void
    ) -> Self {
        let upstream = Observable<Action>.create { observer in
            let send = Send(observer: observer)
            let task = Task {
                await operation(send)
                observer.onCompleted()
            }
            return Disposables.create { task.cancel() }
        }
        return Effect(upstream: upstream)
    }
    
    /// A wrapper to send actions from within an Effect's operation.
    struct Send: Sendable {
        let observer: AnyObserver<Action>
        
        @MainActor
        func callAsFunction(_ action: Action) {
            observer.onNext(action)
        }
    }
}

// MARK: - Store

/// A generic, MVI-compliant Store that manages a feature's state.
/// It uses a Reducer to process actions and execute effects.
class Store<State, Action, Dependency>: ViewModelProtocol {
    
    // MARK: - ViewModelProtocol Conformance
    
    let action = PublishRelay<Action>()
    let state: Driver<State>
    
    // MARK: - Private Properties
    
    private let stateRelay: BehaviorRelay<State>
    private let disposeBag = DisposeBag()

    init(
        initialState: State,
        reducer: @escaping (inout State, Action, Dependency) -> Effect<Action>?,
        dependency: Dependency
    ) {
        self.stateRelay = BehaviorRelay(value: initialState)
        self.state = stateRelay.asDriver()

        action
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                
                var currentState = self.stateRelay.value
                
                guard let effect = reducer(&currentState, action, dependency) else {
                    self.stateRelay.accept(currentState)
                    return
                }
                
                self.stateRelay.accept(currentState)
                
                effect.upstream
                    .subscribe(onNext: { [weak self] action in
                        self?.action.accept(action)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}
