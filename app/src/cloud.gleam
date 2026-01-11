import gleam/list
import lustre/attribute.{attribute, class}
import lustre/element.{type Element}
import lustre/element/html.{div, img}

type CloudConfig {
  CloudConfig(
    src: String,
    position_classes: String,
    size_class: String,
    opacity_class: String,
    animation_class: String,
  )
}

fn cloud_decoration(config: CloudConfig) -> Element(a) {
  img([
    attribute.src(config.src),
    attribute("alt", ""),
    attribute("aria-hidden", "true"),
    class(
      "absolute pointer-events-none select-none "
      <> config.position_classes
      <> " "
      <> config.size_class
      <> " "
      <> config.opacity_class
      <> " "
      <> config.animation_class,
    ),
  ])
}

pub fn cloud_decorations() -> Element(a) {
  let clouds = [
    // 左上
    CloudConfig(
      src: "/image/pattern/cloud_0.svg",
      position_classes: "-top-8 -left-12 md:-top-6 md:-left-8",
      size_class: "w-56 md:w-80",
      opacity_class: "opacity-50",
      animation_class: "animate-drift-slow",
    ),
    // 右上
    CloudConfig(
      src: "/image/pattern/cloud_3.svg",
      position_classes: "top-8 -right-16 md:top-12 md:-right-12",
      size_class: "w-52 md:w-72",
      opacity_class: "opacity-50",
      animation_class: "animate-drift-medium",
    ),
    // 左下
    CloudConfig(
      src: "/image/pattern/cloud_1.svg",
      position_classes: "bottom-4 -left-16 md:bottom-8 md:-left-12",
      size_class: "w-64 md:w-96",
      opacity_class: "opacity-90",
      animation_class: "animate-drift-fast",
    ),
    // 右下 (md以上で表示)
    CloudConfig(
      src: "/image/pattern/cloud_10.svg",
      position_classes: "hidden md:block -bottom-4 -right-16 md:bottom-0 md:-right-12",
      size_class: "w-56 md:w-80",
      opacity_class: "opacity-90",
      animation_class: "animate-drift-medium",
    ),
    // 上端中央やや右 (md以上で表示)
    CloudConfig(
      src: "/image/pattern/cloud_7.svg",
      position_classes: "hidden md:block -top-4 right-1/4",
      size_class: "w-48 md:w-64",
      opacity_class: "opacity-40",
      animation_class: "animate-drift-slow",
    ),
  ]
  div(
    [class("absolute inset-0 z-0 overflow-hidden")],
    list.map(clouds, cloud_decoration),
  )
}
