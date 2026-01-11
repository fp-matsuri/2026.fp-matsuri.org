import lustre/attribute.{class}
import lustre/element.{type Element}
import lustre/element/html.{br, div, h2, p, section, text}

pub fn about_section() -> Element(msg) {
  section([class("py-20 px-6 bg-base-100")], [
    div([class("max-w-2xl mx-auto")], [
      div(
        [
          class(
            "card bg-neutral text-neutral-content border border-subtle shadow-none",
          ),
        ],
        [
          div([class("card-body p-8 md:p-10")], [
            h2([class("card-title text-xl md:text-2xl mb-6 justify-center")], [
              text("関数型プログラミングのカンファレンス"),
              br([]),
              text("「関数型まつり 2026」を開催します！"),
            ]),
            p([class("text-base leading-relaxed")], [
              text(
                "昨年の「関数型まつり」では、参加者総数494名、登壇者48名による多様なセッションを実施し、言語コミュニティの垣根を越えた交流と学びが生まれました。
              好評をいただき、今年も「関数型まつり 2026」を開催します！",
              ),
            ]),
            div([class("divider")], []),
            p([class("mb-4 text-base leading-relaxed")], [
              text(
                "関数型プログラミングはメジャーな言語・フレームワークに取り入れられ、広く使われるようになりました。
そしてその手法自体も進化し続けています。
その一方で「関数型プログラミング」というと「難しい・とっつきにくい」という声もあり、十分普及し切った状態ではありません。",
              ),
            ]),
            p([class("text-base leading-relaxed")], [
              text(
                "私たちは様々な背景の方々が関数型プログラミングを通じて新しい知見を得て、交流ができるような場を提供することを目指しています。
普段から関数型言語を活用している方や関数型プログラミングに興味がある方はもちろん、最先端のソフトウェア開発技術に興味がある方もぜひご参加ください！",
              ),
            ]),
          ]),
        ],
      ),
    ]),
  ])
}
