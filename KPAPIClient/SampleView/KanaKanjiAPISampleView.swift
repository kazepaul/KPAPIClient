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

    @State private var isKanaKanjiOptionSelectionEnable = true
    @State private var isKanaKanjiDictionarySelectionEnable = true

    @State private var isKanaKanjiModeSelectionSheet = false
    @State private var isKanaKanjiOptionSelectionSheet = false
    @State private var isKanaKanjiDictionarySelectionSheet = false

    @State private var textToAPI: String = ""
    @State private var APIResponseText: String = ""
    
    @State var isAPILoading:Bool = false

    // API Request Para Related
    @State private var KanaKanjiFormatSelection = 0
    @State private var KanaKanjiModeSelection = 0
    @State private var KanaKanjiOptionSelectedArray:[Bool] = Array(repeating: false, count: KanaKanjiOption.allCases.count)
    @State private var KanaKanjiDictionarySelectedArray:[Bool] = Array(repeating: false, count: KanaKanjiDictionary.allCases.count)

    let session = KPAPISession(session: Session.default)
    
    var body: some View {
        ZStack{
            if self.isAPILoading {
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
                TextField("文章を入力してください", text: $textToAPI)
                    .textFieldStyle(.roundedBorder)
                    .border(.gray, width: 1)
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
                VStack {
                    HStack {
                        HStack {
                            Text("フォーマット: ")
                                .lineLimit(1)
                            Spacer()
                            Picker("フォーマットを選びください", selection: $KanaKanjiFormatSelection) {
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
                            isAPILoading = true
                            if textToAPI.isEmpty {
                                APIResponseText = "文章を入力してください"
                                isAPILoading = false
                            }
                            else {
                                let optionArray = zip(KanaKanjiOptionSelectedArray, KanaKanjiOption.allCases).filter { $0.0 }.map { $1 }
                                let dictionaryArray = zip(KanaKanjiDictionarySelectedArray, KanaKanjiDictionary.allCases).filter{ $0.0 }.map { $1 }

                                session.request(api: KanaKanjiAPIRequest(text: textToAPI,
                                                                         format: KanaKanjiFormat.allCases[KanaKanjiFormatSelection],
                                                                         mode: KanaKanjiMode.allCases[KanaKanjiModeSelection],
                                                                         option: isKanaKanjiOptionSelectionEnable ? optionArray : nil,
                                                                         dictionary: isKanaKanjiDictionarySelectionEnable ? dictionaryArray : nil)) { result in
                                    switch result {
                                        case let .success(model):
                                        APIResponseText = model.description
                                        case let .failure(error):
                                        APIResponseText = error.localizedDescription
                                    }
                                    isAPILoading = false
                                }
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
                                Text(KanaKanjiMode.allCases[KanaKanjiModeSelection].description)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .border(.black, width: 1)
                        }
                        .sheet(isPresented: $isKanaKanjiModeSelectionSheet) {
                            Text("変換モード")
                                .padding()
                            List(KanaKanjiMode.allCases, id: \.self) { mode in
                                Button {
                                    KanaKanjiModeSelection = KanaKanjiMode.allCases.firstIndex(of: mode) ?? 0
                                    if mode == .roman || mode == .predictive {
                                        isKanaKanjiOptionSelectionEnable = false
                                        isKanaKanjiDictionarySelectionEnable = false
                                    } else {
                                        isKanaKanjiOptionSelectionEnable = true
                                        isKanaKanjiDictionarySelectionEnable = true
                                    }
                                    isKanaKanjiModeSelectionSheet = false
                                } label: {
                                    Text(mode.description)
                                }
                            }
                            .listStyle(.plain)
                            Button("閉じる") {
                                isKanaKanjiModeSelectionSheet = false
                            }
                            .padding()
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
                            VStack {
                                if !KanaKanjiOptionSelectedArray.contains(true) {
                                    HStack{
                                        Text("なし")
                                            .frame(maxWidth: .infinity, alignment: .center)
                                    }
                                    .border(.black, width: 1)
                                } else {
                                    ForEach (0..<KanaKanjiOptionSelectedArray.count) { option in
                                        HStack{
                                            if KanaKanjiOptionSelectedArray[option] {
                                                Spacer()
                                                Text(KanaKanjiOption.allCases[option].title)
                                                    .frame(maxWidth: .infinity, alignment: .center)
                                            }
                                            
                                        }
                                        .border(.black, width: 1)
                                    }
                                }
                            }
                        }
                        .sheet(isPresented: $isKanaKanjiOptionSelectionSheet) {
                            Text("指定変換候補")
                                .padding()
                            List(0..<KanaKanjiOption.allCases.count) { option in
                                Button {
                                    KanaKanjiOptionSelectedArray[option].toggle()
                                } label: {
                                    HStack {
                                        Text("\(KanaKanjiOption.allCases[option].title): \(KanaKanjiOption.allCases[option].description)")
                                        Spacer()
                                        if KanaKanjiOptionSelectedArray[option] {
                                            Text("✅")
                                        } else {
                                            Text("🔲")
                                        }
                                    }
                                }
                            }
                            .listStyle(.plain)

                            Button("閉じる") {
                                isKanaKanjiOptionSelectionSheet = false
                            }
                            .padding()
                        }

                    }
                    .padding(5)
                    .disabled(!isKanaKanjiOptionSelectionEnable)

                    HStack {
                        Text("辞書指定: ")
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: true)
                        Button {
                            isKanaKanjiDictionarySelectionSheet = true
                        } label: {
                            VStack {
                                if !KanaKanjiDictionarySelectedArray.contains(true) {
                                    HStack{
                                        Text("なし")
                                            .frame(maxWidth: .infinity, alignment: .center)
                                    }
                                    .border(.black, width: 1)
                                } else {
                                    ForEach (0..<KanaKanjiDictionarySelectedArray.count) { dictionary in
                                        HStack{
                                            if KanaKanjiDictionarySelectedArray[dictionary] {
                                                Spacer()
                                                Text(KanaKanjiDictionary.allCases[dictionary].title)
                                                    .frame(maxWidth: .infinity, alignment: .center)
                                            }
                                        }
                                        .border(.black, width: 1)
                                    }
                                }
                            }
                        }
                        .sheet(isPresented: $isKanaKanjiDictionarySelectionSheet) {
                            Text("辞書指定")
                                .padding()
                            List(0..<KanaKanjiDictionary.allCases.count) { dictionary in
                                Button {
                                    KanaKanjiDictionarySelectedArray[dictionary].toggle()
                                } label: {
                                    HStack {
                                        Text("\(KanaKanjiDictionary.allCases[dictionary].title): \(KanaKanjiDictionary.allCases[dictionary].description)")
                                        Spacer()
                                        if KanaKanjiDictionarySelectedArray[dictionary] {
                                            Text("✅")
                                        } else {
                                            Text("🔲")
                                        }
                                    }
                                }
                            }
                            .listStyle(.plain)

                            Button("閉じる") {
                                isKanaKanjiDictionarySelectionSheet = false
                            }
                            .padding()
                        }

                    }
                    .padding(5)
                    .disabled(!isKanaKanjiDictionarySelectionEnable)
                }

                ScrollView {
                    Text(APIResponseText)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .border(.black, width: 0.5)
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 5))
            }
            .navigationBarTitle(Text("KanaKanjiAPISampleView"), displayMode: .inline)
            .navigationBarItems(
                leading: Button("戻る") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct KanaKanjiAPISampleView_Previews: PreviewProvider {
    static var previews: some View {
        KanaKanjiAPISampleView()
    }
}
