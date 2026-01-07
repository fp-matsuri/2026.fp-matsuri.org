/**
 * Foreign Function Interface for app.gleam
 */

/**
 * ページタイトルを更新する
 * @param {string} title - 新しいページタイトル
 */
export function setDocumentTitle(title) {
  document.title = title;
}

/**
 * Open Graph Protocol (OGP) メタタグを動的に更新する
 * @param {string} title - OGタイトル
 * @param {string} description - OG説明文
 * @param {string} url - OG URL
 */
export function setOgpTags(title, description, url) {
  const metaTags = {
    "og:title": title,
    "og:description": description,
    "og:url": url,
  };

  Object.entries(metaTags).forEach(([property, content]) => {
    let meta = document.querySelector(`meta[property="${property}"]`);
    if (meta) {
      meta.setAttribute("content", content);
    }
  });
}
