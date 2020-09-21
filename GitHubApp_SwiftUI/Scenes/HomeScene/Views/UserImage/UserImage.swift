






import SwiftUI

struct UserImage: View {
  
  
  @ObservedObject var imageLoader: ImageLoader 
  @State var isImageLoaded = false
  
  var size = UserImageStyle.Size.medium
  
  
  var body: some View {
    ZStack {
      
      if self.imageLoader.imageLoaded {
        
        Image(uiImage: self.imageLoader.image!)
          .resizable()
          .renderingMode(.original)
          .imageStyle(loaded: true, size: size)

      } else {
        Rectangle()
          .foregroundColor(.gray)
          .imageStyle(loaded: false, size: size)
      }
      
      
    }
  }
}

