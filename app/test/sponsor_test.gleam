import sponsor.{Cheerleader, Gold, Individual, Logo, Platinum, Sponsor}

pub fn load_all_returns_sponsors_by_plan_test() {
  let assert [Sponsor(plan: Platinum, ..)] = sponsor.platinum_sponsors()
  let assert [Sponsor(plan: Gold, ..), ..] = sponsor.gold_sponsors()
  let assert [Sponsor(plan: Logo, ..), ..] = sponsor.logo_sponsors()
  let assert [Sponsor(plan: Cheerleader, ..), ..] =
    sponsor.cheerleader_sponsors()
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

  let result = sponsor.parse("test_sponsor", content)

  let assert Ok(Sponsor(
    slug: "test_sponsor",
    name: "Test Sponsor",
    image: "/image/sponsors/sample.png",
    href: "https://example.com",
    plan: Gold,
    kind: Individual,
    description: "<p>This is a test sponsor.\nAnd it has a description with *<strong>markdown</strong>*.</p>\n<p>multiple lines.</p>\n",
    units: 1,
  )) = result
}

pub fn parse_sponsor_with_units_test() {
  let content =
    "---
name = \"Test Cheerleader\"
image = \"/image/sponsors/sample.png\"
href = \"https://example.com\"
plan = \"cheerleader\"
kind = \"individual\"
units = 10
---"

  let result = sponsor.parse("test_cheerleader", content)

  let assert Ok(Sponsor(plan: Cheerleader, units: 10, ..)) = result
}
