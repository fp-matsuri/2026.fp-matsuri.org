import lustre/attribute.{attribute, class, href, rel, src, target}
import lustre/element.{type Element}
import lustre/element/html.{a, div, img}

pub fn navbar() -> Element(msg) {
  div([class("navbar bg-base-100 px-4")], [
    div([class("navbar-start")], [
      a([href("/")], [
        img([
          src("/image/logo_horizontal.svg"),
          attribute("alt", "関数型まつり"),
          class("w-[150px]"),
        ]),
      ]),
    ]),
    div([class("navbar-end gap-1")], [
      social_link(
        label: "Follow us on X",
        url: "https://x.com/fp_matsuri",
        icon: "/icons/x.svg",
      ),
      social_link(
        label: "Bluesky",
        url: "https://bsky.app/profile/fp-matsuri.bsky.social",
        icon: "/icons/bluesky.svg",
      ),
      social_link(
        label: "関数型まつり運営ブログ",
        url: "https://blog.fp-matsuri.org/",
        icon: "/icons/hatenablog.svg",
      ),
    ]),
  ])
}

fn social_link(
  label label: String,
  url url: String,
  icon icon: String,
) -> Element(msg) {
  a(
    [
      href(url),
      target("_blank"),
      rel("noopener noreferrer"),
      attribute("aria-label", label),
      class("btn btn-ghost btn-circle border-none hover:bg-base-300"),
    ],
    [
      img([
        src(icon),
        attribute("alt", label),
        class("w-6 h-6"),
      ]),
    ],
  )
}
