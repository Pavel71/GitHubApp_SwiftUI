






import SwiftUI

struct UserImage: View {
  
  
  @ObservedObject var imageLoader: ImageLoader 
  @State var isImageLoaded = false
  
  var size = UserImageStyle.Size.medium
  
  
  var body: some View {
    ZStack {
      if self.imageLoader.image != nil {
        Image(uiImage: self.imageLoader.image!)
          .resizable()
          .renderingMode(.original)
          
          .imageStyle(loaded: true, size: size)
          .animation(.easeInOut)
          .onAppear{
            self.isImageLoaded = true
        }
      } else {
        Rectangle()
          .foregroundColor(.gray)
          .imageStyle(loaded: false, size: size)
      }
    }
  }
}

