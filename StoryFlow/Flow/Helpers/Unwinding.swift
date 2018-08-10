import Foundation
import UIKit

extension UIViewController {

    func unwindVc(for updateType: Any.Type) -> UIViewController? {

        if canHandle(updateType) {
            return self
        } else if let vc = navBackStack?.first(where: { $0.canHandle(updateType) }) {
            return vc
        } else {
            return presentingViewController?.unwindVc(for: updateType)
        }
    }

    func handleUpdate(_ value: Any, _ type: Any.Type) {
        visibleVcs.forEach { $0.asVc(for: type)?._handleAny(update: value) }
    }
}

private extension UIViewController {

    func canHandle(_ updateType: Any.Type) -> Bool {
        return visibleVcs.contains { $0.isVc(for: updateType) }
    }

    var visibleVcs: [UIViewController] {
        if let nav = self as? UINavigationController {
            guard let top = nav.topViewController else { return [self] }
            return [self] + top.visibleVcs
        } else {
            return [self] + childViewControllers.flatMap { $0.visibleVcs }
        }
    }

    var navBackStack: ArraySlice<UIViewController>? {
        guard let nav = navigationController ?? self as? UINavigationController else { return nil }
        return nav.viewControllers.reversed().dropFirst()
    }

    func isVc(for updateType: Any.Type) -> Bool {
        return asVc(for: updateType) != nil
    }

    typealias UpdateHandlingVc = UIViewController & _AnyUpdateHandling

    func asVc(for updateType: Any.Type) -> UpdateHandlingVc? {
        guard let vc = self as? UpdateHandlingVc else { return nil }

        let vcUpdateType = type(of: vc)._updateType
        guard vcUpdateType == updateType || oneOf(vcUpdateType, contains: updateType) else { return nil }

        return vc
    }
}

private func oneOf(_ vcUpdateType: Any.Type, contains updateType: Any.Type) -> Bool {
    guard let oneOfType = vcUpdateType as? OneOfNType.Type else { return false }
    return oneOfType.valueTypes.contains { $0 == updateType }
}