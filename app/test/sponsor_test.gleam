import sponsor.{Gold, Logo, Platinum, Silver, Sponsor}

pub fn load_all_returns_sponsors_by_plan_test() {
  // 1 platinum sponsor now
  let assert [Sponsor(plan: Platinum, ..)] = sponsor.platinum_sponsors()

  // sample sponsors

  let assert [Sponsor(plan: Gold, ..), ..] = sponsor.gold_sponsors()
  let assert [Sponsor(plan: Silver, ..), ..] = sponsor.silver_sponsors()
  let assert [Sponsor(plan: Logo, ..), ..] = sponsor.logo_sponsors()
}

pub fn parse_valid_sponsor_test() {
  let content =
    "---
name = \"Test Sponsor\"
image = \"/image/sponsors/sample.png\"
href = \"https://example.com\"
plan = \"Gold\"
---
This is a test sponsor.
And it has a description with **markdown**.

multiple lines."

  let result = sponsor.parse(content)

  let assert Ok(Sponsor(
    name: "Test Sponsor",
    image: "/image/sponsors/sample.png",
    href: "https://example.com",
    plan: Gold,
    description: "<p>This is a test sponsor.\nAnd it has a description with *<strong>markdown</strong>*.</p>\n<p>multiple lines.</p>\n",
  )) = result
}
