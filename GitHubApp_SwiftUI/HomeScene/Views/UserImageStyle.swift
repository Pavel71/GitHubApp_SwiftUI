//



import SwiftUI

struct UserImageStyle: ViewModifier {
    enum Size {
        case medium
        
        func width() -> CGFloat {
         return 120
        }
        func height() -> CGFloat {
          return 120
        }
    }
    
    let loaded: Bool
    let size: Size
    
    func body(content: Content) -> some View {
        return content
            .frame(width: size.width(), height: size.height())
            .cornerRadius(5)
            .opacity(loaded ? 1 : 0.1)
            .shadow(radius: 8)
    }
}

extension View {
    func imageStyle(loaded: Bool, size: UserImageStyle.Size) -> some View {
        return ModifiedContent(content: self, modifier: UserImageStyle(loaded: loaded, size: size))
    }
}
