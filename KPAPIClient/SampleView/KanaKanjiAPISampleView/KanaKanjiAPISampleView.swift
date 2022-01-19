//
//  KanaKanjiAPITestView.swift
//  KPAPIClient
//
//  Created by Chan, Paul | Paul on 2022/01/10.
//

import SwiftUI
import Alamofire

struct KanaKanjiAPISampleView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isKanaKanjiModeSelectionSheet = false
    @State private var isKanaKanjiOptionSelectionSheet = false
    @State private var isKanaKanjiDictionarySelectionSheet = false

    @ObservedObject private var viewModel = KanaKanjiViewModel()
    
    var body: some View {
        ZStack{
            if viewModel.status == .Loading {
                Color(red: 0, green: 0, blue: 0, opacity: 0.3)
                    .ignoresSafeArea()
                    .zIndex(1)
                ProgressView("ロード中")
                    .scaleEffect(x: 1, y: 1, anchor: .center)
                    .padding(.all, 24)
                    .background(Color.white)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                    .cornerRadius(16)
                    .zIndex(2)
            }
            VStack {
                TextField("文章を入力してください", text: $viewModel.textToAPI)
                    .textFieldStyle(.roundedBorder)
                    .overlay(RoundedRectangle(cornerRadius: 5.0).strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
                VStack {
                    HStack {
                        HStack {
                            Text("フォーマット: ")
                            Spacer()
                            Picker("フォーマットを選びください", selection: $viewModel.KanaKanjiFormatSelection) {
                                ForEach(0..<KanaKanjiFormat.allCases.count) { index in
                                    Text(KanaKanjiFormat.allCases[index].title)
                                }
                            }
                            .labelsHidden()
                            .compositingGroup()
                            .clipped()
                            Spacer()
                        }
                        Button("送信") {
                            hideKeyboard()
                            if !viewModel.textToAPI.isEmpty {
                                viewModel.fetch()
                            }
                        }
                        .frame(maxWidth: 70, maxHeight: 30)
                        .buttonBorderShape(ButtonBorderShape.roundedRectangle)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth:1))
                    }
                    .padding(5)
                    
                    HStack {
                        Text("変換モード: ")
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: true)
                        Button {
                            isKanaKanjiModeSelectionSheet = true
                        } label: {
                            HStack{
                                Text(KanaKanjiMode.allCases[viewModel.KanaKanjiModeSelection].description)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .overlay(RoundedRectangle(cornerRadius: 5.0).strokeBorder(Color.black, style: StrokeStyle(lineWidth: 1.0)))
                        }
                        .sheet(isPresented: $isKanaKanjiModeSelectionSheet) {
                            KanaKanjiModeListView(viewModel: viewModel, isPresented: $isKanaKanjiModeSelectionSheet)
                        }
                    }
                    .padding(5)
                    
                    HStack {
                        Text("指定変換候補: ")
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: true)
                        
                        Button {
                            isKanaKanjiOptionSelectionSheet = true
                        } label: {
                            VStack(spacing: 0) {
                                if !viewModel.KanaKanjiOptionSelectedArray.contains(true) {
                                    HStack{
                                        Text("なし")
                                            .frame(maxWidth: .infinity, alignment: .center)
                                    }
                                } else {
                                    let selectedOptionArray = viewModel.selectedOptionArray
                                    ForEach (selectedOptionArray, id:\.self) { option in
                                        HStack{
                                            Spacer()
                                            Text(option.title)
                                                .frame(maxWidth: .infinity, alignment: .center)
                                        }
                                        if option != selectedOptionArray.last {
                                            Divider()
                                        }
                                    }
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 5.0).strokeBorder(Color.black, style: StrokeStyle(lineWidth: 1.0)))

                        }
                        .sheet(isPresented: $isKanaKanjiOptionSelectionSheet) {
                            KanaKanjiOptionListView(viewModel: viewModel, isPresented: $isKanaKanjiOptionSelectionSheet)
                        }
                    }
                    .padding(5)
                    .disabled(!viewModel.isKanaKanjiOptionSelectionEnable)

                    HStack {
                        Text("辞書指定: ")
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: true)
                        
                        Button {
                            isKanaKanjiDictionarySelectionSheet = true
                        } label: {
                            VStack(spacing: 0) {
                                if !viewModel.KanaKanjiDictionarySelectedArray.contains(true) {
                                    HStack{
                                        Text("なし")
                                            .frame(maxWidth: .infinity, alignment: .center)
                                    }
                                    .overlay(RoundedRectangle(cornerRadius: 5.0).strokeBorder(Color.black, style: StrokeStyle(lineWidth: 1.0)))
                                } else {
                                    let selectedDictionaryArray = viewModel.selectedDictionaryArray
                                    ForEach (selectedDictionaryArray, id:\.self) { dictionary in
                                        HStack{
                                            Spacer()
                                            Text(dictionary.title)
                                                .frame(maxWidth: .infinity, alignment: .center)
                                        }
                                        if dictionary != selectedDictionaryArray.last {
                                            Divider()
                                        }
                                    }
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 5.0).strokeBorder(Color.black, style: StrokeStyle(lineWidth: 1.0)))
                        }
                        .sheet(isPresented: $isKanaKanjiDictionarySelectionSheet) {
                            KanaKanjiDictionaryListView(viewModel: viewModel, isPresented: $isKanaKanjiDictionarySelectionSheet)
                        }

                    }
                    .padding(5)
                    .disabled(!viewModel.isKanaKanjiDictionarySelectionEnable)
                }

                ScrollView {
                    Text(viewModel.response?.description ?? "")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .border(.black, width: 0.5)
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 5))
            }
            .navigationBarTitle(Text("KanaKanjiAPISample"), displayMode: .inline)
            .navigationBarItems(
                leading: Button("戻る") {
                    self.presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("リセット") {
                    self.viewModel.reset()
                }
            )
            .navigationBarBackButtonHidden(true)
        }
        .alert(isPresented: Binding<Bool>(
            get: { self.viewModel.status == .APIFailure },
            set: { _ in self.viewModel.status = .Idle }
        )) {
            Alert(title: Text(self.viewModel.error?.description ?? "Error"),
                  message: nil,
                  dismissButton: .default(Text("OK")))
        }
        .disabled(viewModel.status == .Loading)
    }
}

struct KanaKanjiAPISampleView_Previews: PreviewProvider {
    static var previews: some View {
        KanaKanjiAPISampleView()
    }
}

// MARK: Subview Classes
struct KanaKanjiModeListView: View {
    @ObservedObject private var viewModel: KanaKanjiViewModel
    
    @Binding var isPresented: Bool

    init(viewModel: KanaKanjiViewModel, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self._isPresented = isPresented
    }
    
    var body: some View {
        Text("変換モード")
            .padding()
        
        List(KanaKanjiMode.allCases, id: \.self) { mode in
            Button {
                viewModel.KanaKanjiModeSelection = KanaKanjiMode.allCases.firstIndex(of: mode) ?? 0
                isPresented = false
            } label: {
                Text(mode.description)
            }
        }
        .listStyle(.plain)
        
        Button("閉じる") {
            isPresented = false
        }
        .padding(5)

    }
}

struct KanaKanjiOptionListView: View {
    @ObservedObject private var viewModel: KanaKanjiViewModel
    @Binding var isPresented: Bool

    init(viewModel: KanaKanjiViewModel, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self._isPresented = isPresented
    }
    
    var body: some View {
        Text("指定変換候補")
            .padding()
        
        List(0..<KanaKanjiOption.allCases.count) { option in
            Button {
                viewModel.KanaKanjiOptionSelectedArray[option].toggle()
            } label: {
                HStack {
                    Text("\(KanaKanjiOption.allCases[option].title): \(KanaKanjiOption.allCases[option].description)")
                    Spacer()
                    if viewModel.KanaKanjiOptionSelectedArray[option] {
                        Text("✅")
                    } else {
                        Text("🔲")
                    }
                }
            }
        }
        .listStyle(.plain)
        
        Button("閉じる") {
            isPresented = false
        }
        .padding(5)
    }
}

struct KanaKanjiDictionaryListView: View {
    @ObservedObject private var viewModel: KanaKanjiViewModel
    @Binding var isPresented: Bool

    init(viewModel: KanaKanjiViewModel, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self._isPresented = isPresented
    }
    
    var body: some View {
        Text("辞書指定")
            .padding()
        List(0..<KanaKanjiDictionary.allCases.count) { dictionary in
            Button {
                viewModel.KanaKanjiDictionarySelectedArray[dictionary].toggle()
            } label: {
                HStack {
                    Text("\(KanaKanjiDictionary.allCases[dictionary].title): \(KanaKanjiDictionary.allCases[dictionary].description)")
                    Spacer()
                    if viewModel.KanaKanjiDictionarySelectedArray[dictionary] {
                        Text("✅")
                    } else {
                        Text("🔲")
                    }
                }
            }
        }
        .listStyle(.plain)
        Button("閉じる") {
            isPresented = false
        }
        .padding(5)
    }
}
