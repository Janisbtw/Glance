import SwiftUI
import libroot

struct HeaderView: View {
  var body: some View {
    VStack {
      Spacer()
      Image(uiImage: UIImage(contentsOfFile: jbRootPath("/Library/Tweak Support/Glance/icon.png"))!.withRenderingMode(.automatic)).resizable().frame(width: 100, height: 100).aspectRatio(contentMode: .fit)
      Text("Glance")
        .font(.system(size: 24, weight: .bold))
    }
    .frame(maxWidth: .infinity, maxHeight: 200)
    .listRowInsets(EdgeInsets())
    .background(Color(UIColor.systemGroupedBackground))
  }
}