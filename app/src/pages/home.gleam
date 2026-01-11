import components/about
import components/hero
import components/staff_recruitment
import layout
import lustre/element.{type Element}
import lustre/element/html.{div}

pub fn page() -> Element(msg) {
  layout.page("関数型まつり 2026", content())
}

fn content() -> Element(msg) {
  div([], [
    hero.hero_section(),
    about.about_section(),
    staff_recruitment.staff_recruitment_section(),
  ])
}
