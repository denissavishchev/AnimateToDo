import SwiftUI

struct ContentView: View {
    
    @State private var title = ""
    @State private var details = ""
    @State private var colors: [Color] = [.red, .yellow, .green, .brown, .purple, .blue, .orange]
    @State private var selectedColor: Color = .red
    @State private var tasks: [Task] = []
    @State private var show = false
    @Namespace private var nameSpace
    @State private var offset = CGSize.zero
    @State private var originalOffset = CGSize.zero
    @State private var showTheView = false
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            List(tasks){ task in
                HStack{
                    Circle().frame(width: 20, height: 20).foregroundStyle(task.color)
                    VStack(alignment: .leading){
                        Text(task.title).bold()
                        Text(task.details).opacity(0.5)
                    }
                }
            }
            if !show{
                ZStack{
                    RoundedRectangle(cornerRadius: 40)
                        .matchedGeometryEffect(id: "add", in: nameSpace)
                        .frame(width: 80, height: 80)
                    Image(systemName: "plus").offset(x: -25, y: -26)
                        .matchedGeometryEffect(id: "add", in: nameSpace)
                        .foregroundStyle(.white).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding()
                .onTapGesture {
                    withAnimation(.spring(dampingFraction: 0.7)){
                        show.toggle()
                    }
                    withAnimation(.easeIn(duration: 0.1).delay(0.3)){
                        showTheView = true
                    }
                    title = ""
                    details = ""
                }
            }else{
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .matchedGeometryEffect(id: "add", in: nameSpace)
                        .frame(width: 300, height: 250)
                        .foregroundStyle(.gray)
                    if showTheView{
                        VStack{
                            HStack{
                                TextField("Title", text: $title)
                                    .padding(.leading, 5)
                                    .frame(width: 150, height: 40)
                                    .background(.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                                Spacer()
                                Button(action: {
                                    showTheView = false
                                    withAnimation(.spring(dampingFraction: 0.7)){
                                        show.toggle()
                                    }
                                }, label: {
                                    Image(systemName: "xmark").foregroundStyle(.black)
                                        .frame(width: 40, height: 40)
                                        .background(.white, in: Circle())
                                })
                            }
                            TextEditor(text: $details)
                                .frame(width: 270, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            HStack{
                                ForEach(colors, id: \.self){color in
                                    Circle().frame(width: 30, height: 30)
                                        .foregroundStyle(color.opacity(0.8))
                                        .overlay{
                                            if color == selectedColor{
                                                Circle().stroke(lineWidth: 2)
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                        .onTapGesture{
                                            selectedColor = color
                                        }
                                }
                            }
                            Button(action: {
                                showTheView = false
                                    withAnimation(.spring(dampingFraction: 0.7)){
                                        show.toggle()
                                    }
                                let newTask = Task(title: title, details: details, color: selectedColor)
                                tasks.append(newTask)
                                title = ""
                                details = ""
                            }, label: {
                                Text("Save").font(.title3).foregroundStyle(.white)
                                    .frame(width: 270, height: 40)
                                    .background(.black, in: RoundedRectangle(cornerRadius: 10))
                            })
                        }
                        .padding()
                        .frame(width: 300, height: 250)
                    }
                }
                .scaleEffect(scale)
                .offset(offset)
                .gesture(
                DragGesture()
                    .onChanged{ gesture in
                        offset = CGSize(width: originalOffset.width + gesture.translation.width, height: originalOffset.height + gesture.translation.height)
                        let distance = sqrt(pow(gesture.translation.width, 2) + pow(gesture.translation.height, 2))
                        scale = max(1.0 - distance / 1000, 0.5)
                    }
                    .onEnded{ gesture in
                        let distance = sqrt(pow(gesture.translation.width, 2) + pow(gesture.translation.height, 2))
                        if distance > 100 {
                            showTheView = false
                            withAnimation(.spring(dampingFraction: 0.7)){
                                show.toggle()
                                scale = 1.0
                            }
                        }else{
                            withAnimation{
                                offset = CGSize.zero
                                originalOffset = CGSize.zero
                                scale = 1.0
                            }
                        }
                    }
                )
            }
        }
        .onChange(of: show){
            offset = CGSize.zero
            originalOffset = CGSize.zero
        }
    }
}

#Preview {
    ContentView()
}
