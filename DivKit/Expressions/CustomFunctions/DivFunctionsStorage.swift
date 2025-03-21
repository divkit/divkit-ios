import LayoutKit
import VGSL

@_spi(Internal)
public final class DivFunctionsStorage {
  private var functions: [CustomFunction.Signature: CustomFunction] = [:]
  private var storages: [UIElementPath: DivFunctionsStorage] = [:]

  private let reporter: DivReporter
  private let lock = AllocatedUnfairLock()

  let outerStorage: DivFunctionsStorage?

  init(
    outerStorage: DivFunctionsStorage? = DivFunctionsStorage(outerStorage: nil),
    reporter: DivReporter = DefaultDivReporter()
  ) {
    self.outerStorage = outerStorage
    self.reporter = reporter
  }

  func set(cardId: DivCardID, functions: [DivFunction]) {
    reset(cardId: cardId)
    setIfNeeded(path: cardId.path, functions: functions)
  }

  func setIfNeeded(path: UIElementPath, functions: [DivFunction]) {
    lock.withLock {
      if storages[path] != nil {
        return
      }

      let nearestStorage = getNearestStorage(path)
      if functions.isEmpty {
        storages[path] = nearestStorage
      } else {
        let storage = DivFunctionsStorage(outerStorage: nearestStorage)
        for function in functions {
          let signature = CustomFunction.Signature(
            name: function.name,
            arguments: function.arguments.map(\.type)
          )
          if storage.functions[signature] != nil {
            reporter.asExpressionErrorTracker(cardId: path.cardId)(
              ExpressionError(
                makeErrorMessage(
                  name: function.name,
                  arguments: function.arguments.map(\.type.rawValue)
                )
              )
            )
          } else {
            storage.functions[signature] = CustomFunction(
              name: function.name,
              arguments: function.arguments.compactMap { arg in
                CustomFunction.Argument(name: arg.name, type: arg.type)
              },
              body: function.body,
              returnType: function.returnType.systemType
            )
          }
        }
        storages[path] = storage
      }
    }
  }

  func getStorage(
    path: UIElementPath,
    contains name: String
  ) -> DivFunctionsStorage? {
    lock.withLock {
      var storage: DivFunctionsStorage? = getNearestStorage(path)
      while storage != nil {
        if storage?.functions.contains(where: { $0.key.name == name }) == true {
          return storage
        }
        storage = storage?.outerStorage
      }
      return nil
    }
  }

  func getFunctions(with name: String) -> [CustomFunction] {
    functions.values.filter { $0.name == name }
  }

  func reset() {
    lock.withLock {
      storages.removeAll()
    }
  }

  func reset(cardId: DivCardID) {
    lock.withLock {
      for path in storages.keys {
        if path.cardId == cardId {
          storages.removeValue(forKey: path)
        }
      }
    }
  }

  func getNearestStorage(_ path: UIElementPath) -> DivFunctionsStorage? {
    var currentPath: UIElementPath? = path
    while let path = currentPath {
      if let storage = storages[path] {
        return storage
      }
      currentPath = path.parent
    }
    return outerStorage
  }
}

private func makeErrorMessage(name: String, arguments: [String]) -> String {
  "Function \(name)(\(arguments.joined(separator: ", "))) declared multiple times."
}
